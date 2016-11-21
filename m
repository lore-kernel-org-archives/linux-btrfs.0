Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-16.italiaonline.it ([212.48.25.144]:43640 "EHLO libero.it"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754448AbcKUSs4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 Nov 2016 13:48:56 -0500
Reply-To: kreijack@inwind.it
Subject: Re: [PATCH] btrfs: raid56: Use correct stolen pages to calculate P/Q
References: <20161121085016.7148-1-quwenruo@cn.fujitsu.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, ce3g8jdj@umail.furryterror.org
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <94606bda-dab0-e7c9-7fc6-1af9069b64fc@inwind.it>
Date: Mon, 21 Nov 2016 19:48:51 +0100
MIME-Version: 1.0
In-Reply-To: <20161121085016.7148-1-quwenruo@cn.fujitsu.com>
Content-Type: multipart/mixed;
 boundary="------------67C1C6BDD2FAAF0CEA60D73B"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------67C1C6BDD2FAAF0CEA60D73B
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit

Hi Qu,

I tested this succefully for RAID5 when doing a scrub (i.e.: I mount a corrupted disks, then I ran "btrfs scrub start ...", then I check the disks).

However if I do a "cat mnt/out.txt" (out.txt is the corrupted file):
1) the system detect that the file is corrupted   (good :) )
2) the system return the correct file content     (good :) )
3) the data on the platter are still wrong        (no good :( )


Enclosed the script which reproduces the problem. Note that:
If I corrupt the data, in the dmesg two time appears a line which says:

[ 3963.763384] BTRFS warning (device loop2): csum failed ino 257 off 0 csum 2280586218 expected csum 3192393815
[ 3963.766927] BTRFS warning (device loop2): csum failed ino 257 off 0 csum 2280586218 expected csum 3192393815

If I corrupt the parity, of course the system doesn't detect the corruption nor try to correct it. But this is the expected behavior.
 
BR
G.Baroncelli



On 2016-11-21 09:50, Qu Wenruo wrote:
> In the following situation, scrub will calculate wrong parity to
> overwrite correct one:
> 
> RAID5 full stripe:
> 
> Before
> |     Dev 1      |     Dev  2     |     Dev 3     |
> | Data stripe 1  | Data stripe 2  | Parity Stripe |
> --------------------------------------------------- 0
> | 0x0000 (Bad)   |     0xcdcd     |     0x0000    |
> --------------------------------------------------- 4K
> |     0xcdcd     |     0xcdcd     |     0x0000    |
> ...
> |     0xcdcd     |     0xcdcd     |     0x0000    |
> --------------------------------------------------- 64K
> 
> After scrubbing dev3 only:
> 
> |     Dev 1      |     Dev  2     |     Dev 3     |
> | Data stripe 1  | Data stripe 2  | Parity Stripe |
> --------------------------------------------------- 0
> | 0xcdcd (Good)  |     0xcdcd     | 0xcdcd (Bad)  |
> --------------------------------------------------- 4K
> |     0xcdcd     |     0xcdcd     |     0x0000    |
> ...
> |     0xcdcd     |     0xcdcd     |     0x0000    |
> --------------------------------------------------- 64K
> 
> The calltrace of such corruption is as following:
> 
> scrub_bio_end_io_worker() get called for each extent read out
> |- scriub_block_complete()
>    |- Data extent csum mismatch
>    |- scrub_handle_errored_block
>       |- scrub_recheck_block()
>          |- scrub_submit_raid56_bio_wait()
>             |- raid56_parity_recover()
> 
> Now we have a rbio with correct data stripe 1 recovered.
> Let's call it "good_rbio".
> 
> scrub_parity_check_and_repair()
> |- raid56_parity_submit_scrub_rbio()
>    |- lock_stripe_add()
>    |  |- steal_rbio()
>    |     |- Recovered data are steal from "good_rbio", stored into
>    |        rbio->stripe_pages[]
>    |        Now rbio->bio_pages[] are bad data read from disk.
>    |- async_scrub_parity()
>       |- scrub_parity_work() (delayed_call to scrub_parity_work)
> 
> scrub_parity_work()
> |- raid56_parity_scrub_stripe()
>    |- validate_rbio_for_parity_scrub()
>       |- finish_parity_scrub()
>          |- Recalculate parity using *BAD* pages in rbio->bio_pages[]
>             So good parity is overwritten with *BAD* one
> 
> The fix is to introduce 2 new members, bad_ondisk_a/b, to struct
> btrfs_raid_bio, to info scrub code to use correct data pages to
> re-calculate parity.
> 
> Reported-by: Goffredo Baroncelli <kreijack@inwind.it>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
> Thanks to the above hell of delayed function all and damn stupid code
> logical, such bug is quite hard to trace.
> 
> The damn kernel scrub is already multi-thread, why do such meaningless
> delayed function call again and again?
> 
> What's wrong with single thread scrub?
> We can do thing like in each stripe for raid56 which is easy and
> straightforward, only delayed thing is to wake up waiter:
> 
> 	lock_full_stripe()
> 	if (!is_parity_stripe()) {
> 		prepare_data_stripe_bios()
> 		submit_and_wait_bios()
> 		if (check_csum() == 0)
> 			goto out;
> 	}
> 	prepare_full_stripe_bios()
> 	submit_and_wait_bios()
> 
> 	recover_raid56_stipres();
> 	prepare_full_stripe_write_bios()
> 	submit_and_wait_bios()
> 
> out:
>   	unlock_full_stripe()
> 
> We really need to re-work the whole damn scrub code.
> 
> Also, we need to enhance btrfs-progs to detect scrub problem(my
> submitted offline scrub is good enough for such usage), and tools to
> corrupt extents reliably to put it into xfstests test cases.
> 
> RAID56 scrub code is neither tested nor well-designed.
> ---
>  fs/btrfs/raid56.c | 29 ++++++++++++++++++++++++++++-
>  1 file changed, 28 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
> index d016d4a..87e3565 100644
> --- a/fs/btrfs/raid56.c
> +++ b/fs/btrfs/raid56.c
> @@ -133,6 +133,16 @@ struct btrfs_raid_bio {
>  	/* second bad stripe (for raid6 use) */
>  	int failb;
>  
> +	/*
> +	 * For steal_rbio, we can steal recovered correct page,
> +	 * but in finish_parity_scrub(), we still use bad on-disk
> +	 * page to calculate parity.
> +	 * Use these members to info finish_parity_scrub() to use
> +	 * correct pages
> +	 */
> +	int bad_ondisk_a;
> +	int bad_ondisk_b;
> +
>  	int scrubp;
>  	/*
>  	 * number of pages needed to represent the full
> @@ -310,6 +320,12 @@ static void steal_rbio(struct btrfs_raid_bio *src, struct btrfs_raid_bio *dest)
>  	if (!test_bit(RBIO_CACHE_READY_BIT, &src->flags))
>  		return;
>  
> +	/* Record recovered stripe number */
> +	if (src->faila != -1)
> +		dest->bad_ondisk_a = src->faila;
> +	if (src->failb != -1)
> +		dest->bad_ondisk_b = src->failb;
> +
>  	for (i = 0; i < dest->nr_pages; i++) {
>  		s = src->stripe_pages[i];
>  		if (!s || !PageUptodate(s)) {
> @@ -998,6 +1014,8 @@ static struct btrfs_raid_bio *alloc_rbio(struct btrfs_root *root,
>  	rbio->stripe_npages = stripe_npages;
>  	rbio->faila = -1;
>  	rbio->failb = -1;
> +	rbio->bad_ondisk_a = -1;
> +	rbio->bad_ondisk_b = -1;
>  	atomic_set(&rbio->refs, 1);
>  	atomic_set(&rbio->error, 0);
>  	atomic_set(&rbio->stripes_pending, 0);
> @@ -2352,7 +2370,16 @@ static noinline void finish_parity_scrub(struct btrfs_raid_bio *rbio,
>  		void *parity;
>  		/* first collect one page from each data stripe */
>  		for (stripe = 0; stripe < nr_data; stripe++) {
> -			p = page_in_rbio(rbio, stripe, pagenr, 0);
> +
> +			/*
> +			 * Use stolen recovered page other than bad
> +			 * on disk pages
> +			 */
> +			if (stripe == rbio->bad_ondisk_a ||
> +			    stripe == rbio->bad_ondisk_b)
> +				p = rbio_stripe_page(rbio, stripe, pagenr);
> +			else
> +				p = page_in_rbio(rbio, stripe, pagenr, 0);
>  			pointers[stripe] = kmap(p);
>  		}
>  
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5

--------------67C1C6BDD2FAAF0CEA60D73B
Content-Type: application/x-sh;
 name="do.sh"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="do.sh"

#!/bin/bash

sudo modprobe loop

# remove the loop device; umount filesystem
( sudo umount mnt
while sudo losetup | egrep "disk..img"; do
	for i in $(sudo losetup | awk '{ print $1 }'); do
		sudo losetup -d $i 
	done
done ) &>/dev/null

disks="disk1.img disk2.img disk3.img"
UUID=11111111-1111-1111-1111-111111111111
offsets="$((81788928+16*4096)) $((61865984+16*4096)) $((61865984+16*4096))"

# sanity check: the test filesystem must be not mounted
[ -d /sys/fs/btrfs/$UUID ] && exit

mydd() {
	dd 2>/dev/null "$@"
}

getn() {
	echo "$1" | cut -d ' ' -f $2
}

myhd() {
	hexdump -v -e '"x" 1/1 "%02X" " "'
}

loops_setup() {
	for i in $disks; do
		sudo losetup -f $i
		sudo btrfs dev scan $(sudo losetup -j $i -O NAME -n)
	done
}

get_loops() {
	for i in $disks; do
		sudo losetup -j $i -O NAME -n
	done
}

loops_destroy() {
	sudo losetup -d $(get_loops)
}

make_disks() {
	sudo losetup | grep loop && exit

	mkdir mnt

	for i in $disks; do
		rm -f $i
		truncate -s 500M $i ; 
	done
	loops_setup

	sudo mkfs.btrfs -U $UUID -d raid5 -m raid5 $(get_loops)
	sudo mount UUID=$UUID mnt/

	python -c "print 'ad'+'a'*65534+'bd'+'b'*65533" | 
		sudo tee mnt/out.txt >/dev/null

	sleep 1
	sudo umount mnt/

	loops_destroy

	sync
	
	# sanitary test
	check_disks || exit
	tar cSzf clean-disks-$UUID.tgz $disks
}

check_disks() {
	data="$(mydd if=disk1.img skip=$(getn "$offsets" 1) bs=1 count=5)"
	[ "$data" != "bdbbb" ] && return 1 
	data="$(mydd if=disk2.img skip=$(getn "$offsets" 2) bs=1 count=5)"
	[ "$data" != "adaaa" ] && return 1
	data="$(mydd if=disk3.img skip=$(getn "$offsets" 3) bs=1 count=5 | myhd)"
	[ "$data" != "x03 x00 x03 x03 x03 " ] && return 1

	return 0


}

corrupt_parity() {
	tar xSzf clean-disks-$UUID.tgz
	echo "11111" | mydd of=$(getn "$disks" 3) bs=1 conv=notrunc \
	        	        seek=$(getn "$offsets" 3) count=5
	check_disks && exit
	tar cSzf corrupt_parity-disks-$UUID.tgz $disks
}

corrupt_disk1() {
	tar xSzf clean-disks-$UUID.tgz
	echo "11111" | mydd of=$(getn "$disks" 1) bs=1 conv=notrunc \
	        	        seek=$(getn "$offsets" 1) count=5
	check_disks && exit
	tar cSzf corrupt_disk1-disks-$UUID.tgz $disks
}

corrupt_disk2() {
	tar xSzf clean-disks-$UUID.tgz
	echo "11111" | mydd of=$(getn "$disks" 2) bs=1 conv=notrunc \
	        	        seek=$(getn "$offsets" 2) count=5
	check_disks && exit
	tar cSzf corrupt_disk2-disks-$UUID.tgz $disks
}

make_imgs() {
	make_disks
	corrupt_disk2
	corrupt_disk1
	corrupt_parity
}

__do_test() {
	j="$1"
	tar xzf $j
	if check_disks; then
		corrupted=0
	else
		corrupted=1
	fi

	loops_setup
	sudo mount UUID=$UUID mnt
	echo 
	echo Test $j
	#sudo btrfs scrub start mnt/.
	cat mnt/out.txt | md5sum

	# sometime umount fail ???
	sudo umount mnt
	while [ -f mnt/out.txt ]; do
		echo "Repeat umount"
		sleep 1s
		sudo umount mnt
	done
	loops_destroy
	sync; sync

	if check_disks; then
			corrected=1
	else
			corrected='0 <-- FAIL!!!!!!!!!!!!!!!!'
	fi
	echo corrupted=$corrupted, corrected=$corrected
	echo premi enter per continuare
	read line
}

do_test() {
	filter="$1"
	for j in *.tgz; do
		if [ -n "$filter" ]; then
			echo "$j" | grep "$filter" || continue
		fi
		__do_test $j
	done
}

#make_imgs
do_test "$1"

--------------67C1C6BDD2FAAF0CEA60D73B--
