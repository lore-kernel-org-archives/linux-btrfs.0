Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-33-i5.italiaonline.it ([212.48.25.234]:37284 "EHLO
	libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757513AbcG1UZY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Jul 2016 16:25:24 -0400
Reply-To: kreijack@inwind.it
Subject: Re: [PATCH 2/5] New btrfs command: "btrfs inspect physical-find"
References: <1469641398-3879-1-git-send-email-kreijack@libero.it>
 <1469641398-3879-3-git-send-email-kreijack@libero.it>
 <8b013280-7128-d6e4-2f62-b43851d6f6cd@cn.fujitsu.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, Chris Mason <clm@fb.com>,
        Goffredo Baroncelli <kreijack@inwind.it>
From: Goffredo Baroncelli <kreijack@libero.it>
Message-ID: <2d33450d-3805-da54-a5e8-2fefde075957@libero.it>
Date: Thu, 28 Jul 2016 22:25:19 +0200
MIME-Version: 1.0
In-Reply-To: <8b013280-7128-d6e4-2f62-b43851d6f6cd@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Qu,

On 2016-07-28 03:47, Qu Wenruo wrote:
> At 07/28/2016 01:43 AM, Goffredo Baroncelli wrote:
>> From: Goffredo Baroncelli <kreijack@inwind.it>
>>
>> The aim of this new command is to show the physical placement on the disk
>> of a file.
>> Currently it handles all the profiles (single, dup, raid1/10/5/6).
>>
>> The syntax is simple:
> 
> Uh...
> Where is the synatx?

:-)

The syntax is:

btrfs inspect-internal physical-find <filename> [-l <logical>|<offset>]

> 
> I guess the synatx is
> physical-find <filename> [<offset>]
> 
>>
>> where:
>>   <filename> is the file to inspect
>>   <offset> is the offset of the file to inspect (default 0)
> 
> Normally <offset> is paired with <length>.
> What about add a new optional parameter <length>?

See my next comment

> Its default value would be the length of the file.
> 
> And for the optional <offset>, would you mind to make it as an option?
> like -o|--offset <offset> and -s|--size <size>?
> 
> For resolve logical directly, then -l|--logical <logical>.
> 
>>
>> Below some examples:
>>
>> ** Single
>>
>> $ sudo mkfs.btrfs -f -d single -m single /dev/loop0
>> $ sudo mount /dev/loop0 mnt/
>> $ python -c "print 'ad'+'a'*65534+'bd'+'b'*65533" | sudo tee mnt/out.txt >/dev/null
>> $ sudo ../btrfs-progs/btrfs inspect physical-find mnt/out.txt
>> mnt/out.txt: 0
> 
> So 0 is the offset inside the file.
> And how long that file extent is?
> 
>>         devid: 1 dev_name: /dev/loop0 offset: 12582912 type: LINEAR
> 
> LINEAR seems a little different, as normally we just call it SINGLE in btrfs.

Right

> 
> And what about changing the output format to the following?
> (This combines both fiemap style and map-logical style)
> ------
> EXT: FILE-OFFSET LOGICAL RANGE DEVICE       DEVICE RANG   TYPE
> 0:   0-128K      XXXXX-XXXXX   1:/dev/loop0 XXXXX-XXXXX   RAID1
>                                2:/dev/loop1 XXXXX-XXXXX   RAID1
> 1:   128K-256K   XXXXX-XXXXX   1:/dev/loop2 XXXXX-XXXXX   RAID5D1
>                                1:/dev/loop3 XXXXX-XXXXX   RAID5D2
>                                1:/dev/loop4 XXXXX-XXXXX   RAID5P
>                  XXXXX-XXXXX   1:/dev/loop2 XXXXX-XXXXX   RAID5D1
>                                1:/dev/loop3 XXXXX-XXXXX   RAID5D2
>                                1:/dev/loop4 XXXXX-XXXXX   RAID5P
> ------
> Extent 0 and 1 are in different raid profile, it's only possible during convert, just used as an exmple
> And Extent 1 are crossing 2 RAID5 stripes, so needs 2 logical range to show them all.

This is "quite clear" from an human point of view. But is a nightmare for a script to parse.. And what is missing is
something like "RAID5U" (U==unrelated) for element of the stripe but not of the file

 
> 
> Although it's quite hard to put the above output into 80 characters per line, it provides almost every info we need:
> 1) File offset and its length
> 2) Logical bytenr and its length
> 3) Device bytenr and its length (since its length can differ from logical length)
> 4) RAID type and its role.

I am not against about your proposal; however I have to point out that the goal of these command was not to *traverse* the file, but only to found the physical location of a file offset. My use case was to simulate a corruption of a raid5 stripe elements: for me it was sufficient to know the page position.

If you want these information to automate a test, I think that the range concept is more a problem than an help.

I suggest to add a third command (btrfs insp ranges ?) which show what are you looking.

> 
> 
>> $ dd 2>/dev/null if=/dev/loop0 skip=12582912 bs=1 count=5; echo
>> adaaa
>>
>> ** Dup
>>
>> The command shows both the copies
>>
>> $ sudo mkfs.btrfs -f -d single -m single /dev/loop0
>> $ sudo mount /dev/loop0 mnt/
>> $ python -c "print 'ad'+'a'*65534+'bd'+'b'*65533" | sudo tee mnt/out.txt >/dev/null
>> $ sudo ../btrfs-progs/btrfs inspect physical-find mnt/out.txt
>> $ sudo ../btrfs-progs/btrfs inspect physical-find mnt/out.txt
>> mnt/out.txt: 0
>>         devid: 1 dev_name: /dev/loop0 offset: 71303168 type: DUP
>>         devid: 1 dev_name: /dev/loop0 offset: 104857600 type: DUP
>> $ dd 2>/dev/null if=/dev/loop0 skip=104857600 bs=1 count=5 ; echo
>> adaaa
>>
>> ** Raid1
>>
>> The command shows both the copies
>>
>> $ sudo mkfs.btrfs -f -d raid1 -m raid1 /dev/loop0 /dev/loop1
>> $ sudo mount /dev/loop0 mnt/
>> $ python -c "print 'ad'+'a'*65534+'bd'+'b'*65533" | sudo tee mnt/out.txt >/dev/null
>> $ sudo ../btrfs-progs/btrfs inspect physical-find mnt/out.txt mnt/out.txt: 0
>>         devid: 2 dev_name: /dev/loop1 offset: 61865984 type: RAID1
>>         devid: 1 dev_name: /dev/loop0 offset: 81788928 type: RAID1
>> $ dd 2>/dev/null if=/dev/loop0 skip=81788928 bs=1 count=5; echo
>> adaaa
>>
>> ** Raid10
>>
>> The command show both the copies; if you set an offset to the next disk-stripe, you can see the next pair of disk-stripe
>>
>> $ sudo mkfs.btrfs -f -d raid10 -m raid10 /dev/loop[0123]
>> $ sudo mount /dev/loop0 mnt/
>> $ python -c "print 'ad'+'a'*65534+'bd'+'b'*65533" | sudo tee mnt/out.txt >/dev/null
>> $ sudo ../btrfs-progs/btrfs inspect physical-find mnt/out.txt mnt/out.txt: 0
>>         devid: 4 dev_name: /dev/loop3 offset: 61931520 type: RAID10
>>         devid: 3 dev_name: /dev/loop2 offset: 61931520 type: RAID10
>> $ dd 2>/dev/null if=/dev/loop2 skip=61931520 bs=1 count=5; echo
>> adaaa
>> $ sudo ../btrfs-progs/btrfs inspect physical-find mnt/out.txt 65536
>> mnt/out.txt: 65536
>>         devid: 2 dev_name: /dev/loop1 offset: 61931520 type: RAID10
>>         devid: 1 dev_name: /dev/loop0 offset: 81854464 type: RAID10
>> $ dd 2>/dev/null if=/dev/loop0 skip=81854464 bs=1 count=5; echo
>> bdbbb
>>
>> ** Raid5
>>
>> Depending by the offset, you can see which disk-stripe is used.
>>
>> $ sudo mkfs.btrfs -f -d raid5 -m raid5 /dev/loop[012]
>> $ sudo mount /dev/loop0 mnt/
>> $ python -c "print 'ad'+'a'*65534+'bd'+'b'*65533" | sudo tee mnt/out.txt >/dev/null
>> $ sudo ../btrfs-progs/btrfs inspect physical-find mnt/out.txt
>> mnt/out.txt: 0
>>         devid: 2 dev_name: /dev/loop1 offset: 61931520 type: DATA
>>         devid: 1 dev_name: /dev/loop0 offset: 81854464 type: OTHER
>>         devid: 3 dev_name: /dev/loop2 offset: 61931520 type: PARITY
> 
> Here DATA/OTHER is a little confusing.
> For 4 disks raid5, will it be DATA/OTHER/OTHER and PARITY?
> 
> What about RAID5D1 for the first data stripe and RAID5D2 for the second?

And what about a data-stripe which is not related to the file which we are examining ?




> 
> So for 4 disks raid5, it will be RAID5D1/D2/D3 and RAID5P (RAID5 PARITY)
> And it's also confusing compared to RAID6.
> 
>> $ sudo ../btrfs-progs/btrfs inspect physical-find mnt/out.txt 65536mnt/out.txt: 65536
>>         devid: 2 dev_name: /dev/loop1 offset: 61931520 type: OTHER
>>         devid: 1 dev_name: /dev/loop0 offset: 81854464 type: DATA
>>         devid: 3 dev_name: /dev/loop2 offset: 61931520 type: PARITY
>> $ dd 2>/dev/null if=/dev/loop1 skip=61931520 bs=1 count=5; echo
>> adaaa
>> $ dd 2>/dev/null if=/dev/loop0 skip=81854464 bs=1 count=5; echo
>> bdbbb
>> $ dd 2>/dev/null if=/dev/loop2 skip=61931520 bs=1 count=5 | xxd
>> 00000000: 0300 0303 03                             .....
>>
>> The parity is computed as: parity=disk1^disk2. So "adaa" ^ "bdbb" == "\x03\x00\x03\x03
>>
>> ** Raid6
>> $ sudo mkfs.btrfs -f -mraid6 -draid6 /dev/loop[0-4]^C
>> $ sudo mount /dev/loop0 mnt/
>> $ python -c "print 'ad'+'a'*65534+'bd'+'b'*65533" | sudo tee mnt/out.txt >/dev/null
>> $ sudo ../btrfs-progs/btrfs inspect physical-find mnt/out.txt
>> mnt/out.txt: 0
>>         devid: 3 dev_name: /dev/loop2 offset: 61931520 type: DATA
>>         devid: 2 dev_name: /dev/loop1 offset: 61931520 type: OTHER
>>         devid: 1 dev_name: /dev/loop0 offset: 81854464 type: PARITY
>>         devid: 4 dev_name: /dev/loop3 offset: 61931520 type: PARITY
> 
> Same like RAID5.
> IMHO RAID6D1/D2... and RAID6P RAID6Q seems better for me.
>>
>> $ dd 2>/dev/null if=/dev/loop2 skip=61931520 bs=1 count=5 ; echo
>> adaaa
>>
>>
>> Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
>> ---
>>  cmds-inspect.c | 587 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 587 insertions(+)
>>
>> diff --git a/cmds-inspect.c b/cmds-inspect.c
>> index dd7b9dd..fc2e7c3 100644
>> --- a/cmds-inspect.c
>> +++ b/cmds-inspect.c
>> @@ -22,6 +22,11 @@
>>  #include <errno.h>
>>  #include <getopt.h>
>>  #include <limits.h>
>> +#include <sys/types.h>
>> +#include <sys/stat.h>
>> +#include <fcntl.h>
>> +#include <linux/fs.h>
>> +#include <linux/fiemap.h>
>>
>>  #include "kerncompat.h"
>>  #include "ioctl.h"
>> @@ -623,6 +628,586 @@ out:
>>      return !!ret;
>>  }
>>
>> +
>> +static const char * const cmd_inspect_physical_find_usage[] = {
>> +    "btrfs inspect-internal physical-find <path> [<off>|-l <logical>]",
>> +    "Show the physical placement of a file data.",
>> +    "<path>     file to show",
> 
> For resolving logical directly, not the file but any file/dir inside the fs though.

Ok
> 
>> +    "<off>      file offset to show; 0 if not specified",
>> +    "<logical>  show info about a logical address instead of a file",
> 
> Mentioned above, use -o|-s|-l options seems to be a better solution.

ok
> 
>> +    "This command requires root privileges",
>> +    NULL
>> +};
>> +
>> +#define STRIPE_INFO_LINEAR        1
>> +#define STRIPE_INFO_DUP            2
>> +#define STRIPE_INFO_RAID0        3
>> +#define STRIPE_INFO_RAID1        4
>> +#define STRIPE_INFO_RAID10        5
>> +#define STRIPE_INFO_RAID56_DATA        6
>> +#define STRIPE_INFO_RAID56_OTHER    7
>> +#define STRIPE_INFO_RAID56_PARITY    8
> 
> Mentioned before.
> And since the STRIPE_INFO_* macro is only used in outputting the string, I prefer to do it in a helper function with if branches.

ok

> 
>> +
>> +static const char * const stripe_info_descr[] = {
>> +    [STRIPE_INFO_LINEAR] = "LINEAR",
>> +    [STRIPE_INFO_DUP] = "DUP",
>> +    [STRIPE_INFO_RAID0] = "RAID0",
>> +    [STRIPE_INFO_RAID1] = "RAID1",
>> +    [STRIPE_INFO_RAID10] = "RAID10",
>> +    [STRIPE_INFO_RAID56_DATA] = "DATA",
>> +    [STRIPE_INFO_RAID56_OTHER] = "OTHER",
>> +    [STRIPE_INFO_RAID56_PARITY] = "PARITY",
>> +};
>> +
>> +struct stripe_info {
>> +    u64 devid;
>> +    const char *dname;
>> +    u64 phy_start;
>> +    int type;
> 
> IMHO "dname" contains all the neede info for the role of the stripe.
> So "type" is useless here for me though.

Sorry I can't understand you: dname is the device name; its role depends by 
several factors, so I add also the type field.

> 
> And it's better to add a "u32 phy_length" to show how long the stripe is.
> 
>> +};
>> +
>> +static void add_stripe_info(struct stripe_info **list, int *count,
>> +    u64 devid, const char *dname, u64 phy_start, int type) {
>> +
>> +    if (*list == NULL)
>> +        *count = 0;
>> +
>> +    ++*count;
>> +    *list = realloc(*list, sizeof(struct stripe_info) * *count);
>> +    /*
>> +     * It is rude, but it should not happen for this kind of allocation...
>> +     * ... and anyway when it happens, there are more severe problems
>> +     * that this handling of "not enough memory"
>> +     */
>> +    if (*list == NULL) {
>> +        error("Not nough memory: abort\n");
>> +        exit(100);
> 
> Same exit value problem here.

ok
[...]


>> +
>> +    } else if (chunk->type & BTRFS_BLOCK_GROUP_RAID1) {
>> +        /*
>> +         * RAID0: each chunk is composed by more disks;
>> +         * each stripe_len bytes are in a different disk:
>> +         *
>> +         *  file: ABC...
>> +         *
>> +         *      disk1   disk2   disk3  ....
>> +         *
>> +         *        A       A
>> +         *        B       B
>> +         *        C       C
>> +         *
>> +         */
> 
> Here btrfs raid1 is more flex than normal RAID1 implement.
> 
> Better comment would be:
>  Disk1   Disk2   Disk3
>   A       A       B
>   B       C       C

ok

> 
> And that's the real case for 3 disks RAID1 (for same disk size).


[...]
>> +static int cmd_inspect_physical_find(int argc, char **argv)
>> +{
>> +    int ret = 0;
[...]
>> +
>> +    check_root_or_exit();
>> +    check_btrfs_or_exit(fname);
> 
> If we call get_fs_info(), is it really needed to check btrfs early?

The two above are the mains reasons of failure of these command. So I 
preferred to add a clear check about which property we want.
I think that is more clear a statemenmt like:
	"You need to be root to execute this command"
instead of a generic EPERM: the user could think that it is
sufficent to change the permission of the file
	

> 
> Thanks,
> Qu

[...]

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
