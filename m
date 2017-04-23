Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f194.google.com ([209.85.217.194]:34257 "EHLO
        mail-ua0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1427831AbdDWHnY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 23 Apr 2017 03:43:24 -0400
Received: by mail-ua0-f194.google.com with SMTP id 110so13827748uas.1
        for <linux-btrfs@vger.kernel.org>; Sun, 23 Apr 2017 00:43:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <9e8c3a66-f43a-bce8-36b1-5f358c6cab4a@cn.fujitsu.com>
References: <20170417032642.30770-1-quwenruo@cn.fujitsu.com>
 <20170417032642.30770-10-quwenruo@cn.fujitsu.com> <CAKuJGC8vX53NExNAYj-de9vta_y5rdv3fC2z9-fP=rPatv-OOg@mail.gmail.com>
 <33ef367f-85a5-8418-d57e-b38b22214487@cn.fujitsu.com> <CAKuJGC9tcGh49XGv+tU729Y0BNnnMEwDk7axGQv6RAV0ZbFCGQ@mail.gmail.com>
 <9e8c3a66-f43a-bce8-36b1-5f358c6cab4a@cn.fujitsu.com>
From: "Lakshmipathi.G" <lakshmipathi.g@gmail.com>
Date: Sun, 23 Apr 2017 13:12:42 +0530
Message-ID: <CAKuJGC9Lcc+0hw7CQCMC2QhEUH1hm1doOxNsPv8Z-sqR4oErkQ@mail.gmail.com>
Subject: Re: [PATCH 9/9] btrfs-progs: modify: Introduce option to specify the
 pattern to fill mirror
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: btrfs <linux-btrfs@vger.kernel.org>, dsterba@suse.cz
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for the example and details. I understood some and need to
re-read couple of more times to understand the remaining.

btw, I created a corruption framework(with previous org), the sample
usage and example is below. It looks similar to Btrfs corruption tool.
thanks.

--
corrupt.py --help
Usage: corrupt.py [options] <arg1> <arg2> <arg3> ...]

Options:
  --version             show program's version number and exit
  -h, --help            show this help message and exit
  -t object, --object=object
                        The object type to be corrupted [ choose from (inode,

l_inner,l_master,l_leaf,fileinode_inner,fileinode_leaf,dirinode_in
                        ner,dirinode_leaf,data_block,fec_block,baddr)
default: inode]
  -p /fs/path, --path=/fs/path
                        The file or directory path in /fs
  -q optype, --optype=optype
                        The corruption operation on the object [choose from
                        (set,xor,add) default: set]
  -o offset, --offset=offset
                        The valid offset value of the object [default:0]
  -m mirror, --mirror=mirror
                        The mirror number [default: 1]
  -s size, --size=size  The offset field/byte to be corrupted [default: 1]
  -c fixcrc, --fixcrc=fixcrc
                        This fixes the CRC's of the corrupted objects
  -n lbn, --lbn=lbn     The lbn of the data block to be corrupted
  -b baddr, --baddr=baddr
                        The baddr to be corrupted
  --log=LOG_FILE        This logs the result into the log file

Example usage:
corrupt.py --object=inode --offset=0 --size=4 --path=/fs/path/to/file.txt
Will corrupt first 4 bytes of inode structure.

corrupt.py --object=dirinode_inner --offset=0 --size=4
--path=/fs/path/to/file.txt
Will corrupt first 4 bytes of directory-inode structure.

corrupt.py --object=dirinode_leaf --offset=0 --size=4
--path=/fs/path/to/file.txt
Will corrupt first 4 bytes of directory-inode leaf structure.
(file.txt should be
large enough to contain leafs).

corrupt.py --object=inode --offset=0 --size=4
--path=/fs/path/to/file.txt  --mirror=2
Will corrupt first 4 bytes of inode structure that reside on Node/drive-2.

--optype=optype ==> default is set. It sets '0' to specified offset.
add => Will try given value to existing value. For example.
offset=(nlink's offset) --optype=add will increase the nlink count by
1.
(running fsck, expected to find this and fix it)

where as optype xor => should flip the bits at given offset.
--

----
Cheers,
Lakshmipathi.G
FOSS Programmer.
http://www.giis.co.in http://www.webminal.org

On Thu, Apr 20, 2017 at 6:30 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>
>
>
> At 04/19/2017 03:46 PM, Lakshmipathi.G wrote:
>>
>> Thanks. This should make easier to create corruption test scripts.
>>
>> when using --root-ino-offset 5,257,0  Does final entry 0 has to be default value ? Does it represent any value at
>> this moment?
>
>
> For case 5,257,0, it means the start point of the corruption is root 5, inode 257 and file offset 0.
>
> So let's take the following file layout as an example (a little complex one, to show off all the ability)
>
> Root 5 inode 257:
>
>        \/ This is file offset
> Extent 0:   disk bytenr X, disk len 4K, nr_bytes 4K offset 0  plain
> Extent 4K:  disk bytenr Y, disk len 8K, nr_bytes 4K offset 0  plain
> Extent 8K:  disk bytenr Z, disk len 8K, nr_bytes 4K offset 4K plain
>
> And if you specified --root-ino-offset 5,257,0 and --length 12288
>
> Then the following on-disk range will be corrupted:
> [X, X+4K)
> [Y, Y+4K)
> [Z+4K, Z+8K)
>
> Making all the 0~12K of root5, inode257 get corrupted, while unrelated ranges like [Z, Z+4K) and [Y+4K, Y+8K) not modified.
>
> While for RAID1/RAID10/DUP usage, just create a file on a new fs, then pass --root-ino-offset 5,257,0 with --length <file_size> will corrupt the whole file for you, allowing us to test recovery.
>
>>
>> One more thing, does btrfs-modify command has option to print out existing parity value (all parity of a file or specific a parity)?
>> something like get_parity option?
>
>
> 1) For print parity value
> I didn't see the need to print parity value.
> As if you want to verify if the parity is good or not, just use offline scrub.
> It will detect parity/data corruption.
>
> 2) For printing/corrupting value of a file in RAID56 profile
> Not as easy as one may think.
>
> Think about the following case:
>
> Root 5 ino 257:
> Extent 0: disk bytenr X(rounded to stripe boundary), disk len 32K, nr_bytes 32K, offset 0.
> Extent 1: disk bytenr X+32K, disk len 64K, nr_bytes 64K, offset 0
>
> On disk it will be:
>
> |    Dev  1       |       Dev   2    |       Dev 3      |
> X                 X+64K              X+128K             X+192K
> |<-Ext 0->|<----- Ext 1---->|        |///// Parity /////|
>
> For Extent 0, it's OK to just print out/corrupt its value, as it's completely inside one data stripe.
>
> But for Extent 1, it crosses 2 device.
> If we corrupt on disk data of Extent1, we will corrupt both data stripe, leaving the full stripe unrecoverable.
>
> So for P/Q corrupting, I'm considering to record which full stripe we have corrupted and never corrupt any full stripe already damaged in next version.
>
> Thanks,
> Qu
>>
>>
>>
>>
>> ----
>> Cheers,
>> Lakshmipathi.G
>> FOSS Programmer.
>> http://www.giis.co.in http://www.webminal.org
>>
>> On Tue, Apr 18, 2017 at 12:43 PM, Qu Wenruo <quwenruo@cn.fujitsu.com <mailto:quwenruo@cn.fujitsu.com>> wrote:
>>
>>
>>
>>     At 04/18/2017 03:05 PM, Lakshmipathi.G wrote:
>>
>>         Nice. With this new option, it should be possible to achieve
>>         something
>>         like RAID56 corruption test-script say,
>>         https://patchwork.kernel.org/patch/9583455/
>>         <https://patchwork.kernel.org/patch/9583455/>  right?
>>
>>
>>     Yes, just for your use case!
>>
>>     It would be much more simpler to craft such recovery test case.
>>
>>     Just create a file in default subvolume (5), write large enough
>>     data, get the file ino (257 for first inode).
>>
>>     Then pass --root-ino-offset 5,257,0 --length 64k --stripe 0 to
>>     corrupt data stripe.
>>     Or change to --stripe P to corrupt parity.
>>
>>     Although it's still a little tricky to use current "--stripe" option
>>     to only corrupt data stripe (above 64K may crosses 2 data stripes).
>>     It shouldn't to be hard to add a new parameter --raid-stripe for
>>     such usage.
>>
>>     But it should be good enough for DUP/RAID1/RAID10.
>>
>>     Thanks,
>>     Qu
>>
>>
>>         ----
>>         Cheers,
>>         Lakshmipathi.G
>>         FOSS Programmer.
>>         http://www.giis.co.in http://www.webminal.org
>>
>>
>>         On Mon, Apr 17, 2017 at 8:56 AM, Qu Wenruo
>>         <quwenruo@cn.fujitsu.com <mailto:quwenruo@cn.fujitsu.com>> wrote:
>>
>>             Introduce a new option, --pattern, to specify the pattern to
>>             fill
>>             mirror.
>>
>>             Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com
>>             <mailto:quwenruo@cn.fujitsu.com>>
>>
>>             ---
>>                Documentation/btrfs-modify.asciidoc |  5 +++++
>>                modify/mirror.c                     | 11 ++++++++++-
>>                2 files changed, 15 insertions(+), 1 deletion(-)
>>
>>             diff --git a/Documentation/btrfs-modify.asciidoc
>>             b/Documentation/btrfs-modify.asciidoc
>>             index ae2ada65..d82fb0df 100644
>>             --- a/Documentation/btrfs-modify.asciidoc
>>             +++ b/Documentation/btrfs-modify.asciidoc
>>             @@ -41,6 +41,11 @@ stripe number 1.
>>                P for RAID56 1st parity stripe. Only RAID5 and RAID6
>>             support stripe number P.
>>                Q for RAID6 2nd parity stripe.
>>
>>             +--pattern <pattern>::::
>>             +Specify to pattern to modify the mirror data5f536652.
>>             ++
>>             +Default value is "0x66524842" (ascii "BHRf", part of the
>>             btrfs magic "_BHRfS_M").
>>             +
>>                EXIT STATUS
>>                -----------
>>                *btrfs-modify* returns a zero exit status if all its
>>             operations succeed.
>>             diff --git a/modify/mirror.c b/modify/mirror.c
>>             index c89927f6..dd717fbe 100644
>>             --- a/modify/mirror.c
>>             +++ b/modify/mirror.c
>>             @@ -373,13 +373,15 @@ int modify_mirror(int argc, char **argv)
>>                       char *device;
>>                       u64 length = (u64)-1;
>>                       u64 logical = (u64)-1;
>>             +       u32 pattern = 0x66524842;
>>                       int stripe = STRIPE_UNINITILIZED;
>>                       int ret;
>>
>>                       while (1) {
>>                               int c;
>>                               enum { GETOPT_VAL_LOGICAL = 257,
>>             GETOPT_VAL_LENGTH,
>>             -                       GETOPT_VAL_STRIPE,
>>             GETOPT_VAL_ROOT_INO_OFFSET };
>>             +                       GETOPT_VAL_STRIPE,
>>             GETOPT_VAL_ROOT_INO_OFFSET,
>>             +                       GETOPT_VAL_PATTERN };
>>                               static const struct option long_options[] = {
>>                                       { "logical", required_argument, NULL,
>>                                               GETOPT_VAL_LOGICAL },
>>             @@ -388,6 +390,8 @@ int modify_mirror(int argc, char **argv)
>>                                       { "stripe", required_argument,
>>             NULL, GETOPT_VAL_STRIPE },
>>                                       { "root-ino-offset",
>>             required_argument, NULL,
>>                                               GETOPT_VAL_ROOT_INO_OFFSET},
>>             +                       { "pattern", required_argument, NULL,
>>             +                               GETOPT_VAL_PATTERN},
>>                                       { NULL, 0, NULL, 0 }
>>                               };
>>
>>             @@ -407,6 +411,9 @@ int modify_mirror(int argc, char **argv)
>>                               case GETOPT_VAL_ROOT_INO_OFFSET:
>>                                       parse_root_ino_offset(&dest, optarg);
>>                                       break;
>>             +               case GETOPT_VAL_PATTERN:
>>             +                       pattern = arg_strtou32(optarg);
>>             +                       break;
>>                               case '?':
>>                               case 'h':
>>                                       usage(modify_mirror_usage);
>>             @@ -439,6 +446,8 @@ int modify_mirror(int argc, char **argv)
>>                               stripe = 0;
>>                       }
>>
>>             +       memset(write_buf, pattern, sizeof(write_buf) /
>>             sizeof(pattern));
>>             +
>>                       fs_info = open_ctree_fs_info(device, 0, 0, 0,
>>             OPEN_CTREE_WRITES);
>>                       if (!fs_info) {
>>                               error("failed to open btrfs on device
>>             %s\n", device);
>>             --
>>             2.12.2
>>
>>
>>
>>             --
>>             To unsubscribe from this list: send the line "unsubscribe
>>             linux-btrfs" in
>>             the body of a message to majordomo@vger.kernel.org
>>             <mailto:majordomo@vger.kernel.org>
>>             More majordomo info at
>>             http://vger.kernel.org/majordomo-info.html
>>             <http://vger.kernel.org/majordomo-info.html>
>>
>>         --
>>         To unsubscribe from this list: send the line "unsubscribe
>>         linux-btrfs" in
>>         the body of a message to majordomo@vger.kernel.org
>>         <mailto:majordomo@vger.kernel.org>
>>         More majordomo info at
>>         http://vger.kernel.org/majordomo-info.html
>>         <http://vger.kernel.org/majordomo-info.html>
>>
>>
>>
>>
>>
>
>
