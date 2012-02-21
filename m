From: Curtis Jones <curtis.jones@gmail.com>
Subject: Re: btrfs open_ctree failed (after recent Ubuntu update)
Date: Mon, 20 Feb 2012 21:30:27 -0500
Message-ID: <59C258B5-F261-41B3-9FC9-48E6E3F158FB@gmail.com>
References: <455D7450-3946-478A-9021-6B01A4D7FB9B@gmail.com> <201202191000.34819.chris@csamuel.org> <FA65D86B-2BF3-49C9-941D-04AFF239523D@gmail.com> <201202192141.13497.chris@csamuel.org> <E271A902-2E12-494D-85D2-FFFD9362FC30@gmail.com> <CAG1y0sdqOuRJ9RJhZ9MEkz8DYyGbsxPOzScAq70jBYE2YOR=tA@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1257)
Content-Type: text/plain; charset=US-ASCII
Cc: Chris Samuel <chris@csamuel.org>, linux-btrfs@vger.kernel.org
To: "Fajar A. Nugraha" <list@fajar.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAG1y0sdqOuRJ9RJhZ9MEkz8DYyGbsxPOzScAq70jBYE2YOR=tA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Fajar,

Thanks for the instructions. I've included some extra detail here for future generations.

I followed the instructions here (https://wiki.archlinux.org/index.php/Btrfs) to obtain the source code for btrfs-zero-log, specifically:

	git clone git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git
	make 
	make btrfs-zero-log

If this isn't the source code I should use, please let me know.

I ran into two dependency issues (uuid/uuid.h and attr/xattr.h) during "make" which I resolved, respectively, with:

	sudo apt-get install uuid-dev
	sudo apt-get install libattr1-dev

And then I ran btrfs-zero-log:

	$ sudo ./btrfs-zero-log /dev/sdb
	parent transid verify failed on 79466496 wanted 33999 found 36704
	parent transid verify failed on 79466496 wanted 33999 found 36704
	parent transid verify failed on 79466496 wanted 33999 found 36704
	parent transid verify failed on 79466496 wanted 33999 found 36704
	Ignoring transid failure
	Unable to find block group for 0
	btrfs-zero-log: extent-tree.c:284: find_search_start: Assertion `!(1)' failed.

I'll have to repurpose another disk to try out your restore suggestion; which I can't do from my presently remote location. If you have any other suggestions, or if the above info spawns any new ideas, please let me know.

Thanks.

--
Curtis Jones
curtisjones.us
404.492.6437




On Feb 20, 2012, at 01.23.00, Fajar A. Nugraha wrote:

> On Mon, Feb 20, 2012 at 10:34 AM, Curtis Jones <curtis.jones@gmail.com> wrote:
>> Chris,
>> 
>> Thank you for those kernel-update instructions. That was the least painful kernel update I could have imagined. I rebooted and verified (via uname) that I am in fact running the new kernel. After looking at dmesg I can confirm that the exact same error is still occurring though. I re-read your previous email and saw that you recommended the 3.3-rc release if 3.2.6 didn't suffice. So I did the same thing with 3.3-rc. And I found the same error (or what appears to be the same error), again:
>> 
>>> [  186.982910] device label StoreW devid 1 transid 37077 /dev/sdb
>>> [  187.015081] parent transid verify failed on 79466496 wanted 33999 found 36704
>>> [  187.015088] parent transid verify failed on 79466496 wanted 33999 found 36704
>>> [  187.015091] parent transid verify failed on 79466496 wanted 33999 found 36704
>>> [  187.015094] parent transid verify failed on 79466496 wanted 33999 found 36704
>>> [  187.015764] btrfs: open_ctree failed
>> 
>> uname now reports:
>> 
>>> Linux veriton 3.3.0-030300rc4-generic-pae #201202181935 SMP Sun Feb 19 00:53:06 UTC 2012 i686 i686 i386 GNU/Linux
>> 
>> I'm not sure what to try next;
> 
> I'd try with latest tools now. IIRC there's two programs you can try:
> - btrfs-zero-log, which (as the name implies) zeroes-out transaction log
> - restore, which would try to read files from a broken btrfs and copy
> it elsewhere, and
> 
> Try the first one. If you can, dump the content of the disk to a file
> first (with dd or dd_rescue) and try it on that file. Just in case
> something goes horribly wrong :)
> 
> -- 
> Fajar

