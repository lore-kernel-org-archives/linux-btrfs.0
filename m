Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from avasout05.plus.net ([84.93.230.250]:55169 "EHLO
        avasout05.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751930AbeD2Jzc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 29 Apr 2018 05:55:32 -0400
From: "David C. Partridge" <david.partridge@perdrix.co.uk>
To: "'Qu Wenruo'" <quwenruo.btrfs@gmx.com>, <linux-btrfs@vger.kernel.org>
References: <003801d3de56$fba1b930$f2e52b90$@perdrix.co.uk> <035a8b69-127a-0b7f-28e0-67c0a3e3f5c7@gmx.com> <003801d3def2$d90965c0$8b1c3140$@perdrix.co.uk> <a5c24cee-ad20-f317-28e8-40e88039db45@gmx.com> <004d01d3def6$4000ed40$c002c7c0$@perdrix.co.uk> <60674123-6fe2-2cfe-e7a8-25d62e023c53@gmx.com> <006201d3defa$2783dda0$768b98e0$@perdrix.co.uk> <0dba3a1c-434a-dc23-5d5d-75151121ffbf@gmx.com> <001701d3df0a$55d7cf30$01876d90$@perdrix.co.uk> <275af8f8-4997-5246-d2a4-99ab2bf299fb@gmx.com> <002f01d3df5d$25dd0270$71970750$@perdrix.co.uk> <c26c307a-75ce-d0f5-ca29-75854c34280c@gmx.com> <002a01d3df93$74b7b760$5e272620$@perdrix.co.uk> <126b8a98-384e-af68-8a36-ad702f07fad2@gmx.com> <000b01d3df9b$40f17fd0$c2d47f70$@perdrix.co.uk> <2471e5c7-fcb6-947e-359a-a59f634c02ca@gmx.com>
In-Reply-To: <2471e5c7-fcb6-947e-359a-a59f634c02ca@gmx.com>
Subject: RE: Problems with btrfs
Date: Sun, 29 Apr 2018 10:55:29 +0100
Message-ID: <003101d3dfa0$35ba0060$a12e0120$@perdrix.co.uk>
MIME-Version: 1.0
Content-Type: multipart/mixed;
        boundary="----=_NextPart_000_0032_01D3DFA8.977EB680"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a multipart message in MIME format.

------=_NextPart_000_0032_01D3DFA8.977EB680
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Yes I did use seek=3D

I attach the new dump-tree - it seems very short compared to the last =
one you requested ???

Dave

-----Original Message-----
From: Qu Wenruo [mailto:quwenruo.btrfs@gmx.com]=20
Sent: 29 April 2018 10:36
To: David C. Partridge; linux-btrfs@vger.kernel.org
Subject: Re: Problems with btrfs



On 2018=E5=B9=B404=E6=9C=8829=E6=97=A5 17:20, David C. Partridge wrote:
> Here is the result of btrfs check after applying the patch

Doesn't work as expected.

Did you apply the patched tree block with "seek=3D"?

If so, please dump extent tree again to verify if the modification is =
done correct.

# btrfs inspect dump-tree -t extent <device>

Thanks,
Qu

>=20
> Dave
> -----Original Message-----
> From: Qu Wenruo [mailto:quwenruo.btrfs@gmx.com]
> Sent: 29 April 2018 09:36
> To: David C. Partridge
> Subject: Re: Problems with btrfs
>=20
> Here is the patched binary tree block.
>=20
> You could apply them by the following command (copy1 and copy2 are the =
same).
>=20
> # dd if=3Dcopy1.img of=3D<device> bs=3D1 count=3D16K =
seek=3D25942081536 # dd=20
> if=3Dcopy1.img of=3D<device> bs=3D1 count=3D16K seek=3D26478952448
>=20
> And after that, try btrfs check to see if it reports new error.
>=20
> Thanks,
> Qu
>=20
> On 2018=E5=B9=B404=E6=9C=8829=E6=97=A5 16:24, David C. Partridge =
wrote:
>> Attached as requested
>>
>> -----Original Message-----
>> From: linux-btrfs-owner@vger.kernel.org=20
>> [mailto:linux-btrfs-owner@vger.kernel.org] On Behalf Of Qu Wenruo
>> Sent: 29 April 2018 03:08
>> To: David C. Partridge; linux-btrfs@vger.kernel.org
>> Subject: Re: Problems with btrfs
>>
>>
>>
>> On 2018=E5=B9=B404=E6=9C=8829=E6=97=A5 09:55, David C. Partridge =
wrote:
>>> Not a problem
>>>
>>> See attached
>>
>> The final binary dump:
>>
>> # dd if=3D<device> of=3D/tmp/copy1.img bs=3D1 count=3D16K =
skip=3D25942081536 #=20
>> dd if=3D<device> of=3D/tmp/copy2.img bs=3D1 count=3D16K =
skip=3D26478952448
>>
>> Thanks,
>> Qu
>>


------=_NextPart_000_0032_01D3DFA8.977EB680
Content-Type: application/octet-stream;
	name="btrfs-dump-tree1.log"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="btrfs-dump-tree1.log"

btrfs: unknown token 'inpect'=0A=
usage: btrfs [--help] [--version] <group> [<group>...] <command> [<args>]=0A=
=0A=
    btrfs subvolume create [-i <qgroupid>] [<dest>/]<name>=0A=
        Create a subvolume=0A=
    btrfs subvolume delete [options] <subvolume> [<subvolume>...]=0A=
        Delete subvolume(s)=0A=
    btrfs subvolume list [options] [-G [+|-]value] [-C [+|-]value] =
[--sort=3Dgen,ogen,rootid,path] <path>=0A=
        List subvolumes (and snapshots)=0A=
    btrfs subvolume snapshot [-r] [-i <qgroupid>] <source> =
<dest>|[<dest>/]<name>=0A=
        Create a snapshot of the subvolume=0A=
    btrfs subvolume get-default <path>=0A=
        Get the default subvolume of a filesystem=0A=
    btrfs subvolume set-default <subvolid> <path>=0A=
        Set the default subvolume of a filesystem=0A=
    btrfs subvolume find-new <path> <lastgen>=0A=
        List the recently modified files in a filesystem=0A=
    btrfs subvolume show <subvol-path>=0A=
        Show more information of the subvolume=0A=
    btrfs subvolume sync <path> [<subvol-id>...]=0A=
        Wait until given subvolume(s) are completely removed from the =
filesystem.=0A=
=0A=
    btrfs filesystem df [options] <path>=0A=
        Show space usage information for a mount point=0A=
    btrfs filesystem du [options] <path> [<path>..]=0A=
        Summarize disk usage of each file.=0A=
    btrfs filesystem show [options] [<path>|<uuid>|<device>|label]=0A=
        Show the structure of a filesystem=0A=
    btrfs filesystem sync <path>=0A=
        Force a sync on a filesystem=0A=
    btrfs filesystem defragment [options] <file>|<dir> [<file>|<dir>...]=0A=
        Defragment a file or a directory=0A=
    btrfs filesystem resize =
[devid:][+/-]<newsize>[kKmMgGtTpPeE]|[devid:]max <path>=0A=
        Resize a filesystem=0A=
    btrfs filesystem label [<device>|<mount_point>] [<newlabel>]=0A=
        Get or change the label of a filesystem=0A=
    btrfs filesystem usage [options] <path> [<path>..]=0A=
        Show detailed information about internal filesystem usage .=0A=
=0A=
    btrfs balance start [options] <path>=0A=
        Balance chunks across the devices=0A=
    btrfs balance pause <path>=0A=
        Pause running balance=0A=
    btrfs balance cancel <path>=0A=
        Cancel running or paused balance=0A=
    btrfs balance resume <path>=0A=
        Resume interrupted balance=0A=
    btrfs balance status [-v] <path>=0A=
        Show status of running or paused balance=0A=
=0A=
    btrfs device add [options] <device> [<device>...] <path>=0A=
        Add a device to a filesystem=0A=
    btrfs device delete <device>|<devid> [<device>|<devid>...] <path>    =
btrfs device remove <device>|<devid> [<device>|<devid>...] <path>=0A=
        Remove a device from a filesystem=0A=
    btrfs device scan [(-d|--all-devices)|<device> [<device>...]]=0A=
        Scan devices for a btrfs filesystem=0A=
    btrfs device ready <device>=0A=
        Check device to see if it has all of its devices in cache for =
mounting=0A=
    btrfs device stats [-z] <path>|<device>=0A=
        Show current device IO stats.=0A=
    btrfs device usage [options] <path> [<path>..]=0A=
        Show detailed information about internal allocations in devices.=0A=
=0A=
    btrfs scrub start [-BdqrRf] [-c ioprio_class -n ioprio_classdata] =
<path>|<device>=0A=
        Start a new scrub. If a scrub is already running, the new one =
fails.=0A=
    btrfs scrub cancel <path>|<device>=0A=
        Cancel a running scrub=0A=
    btrfs scrub resume [-BdqrR] [-c ioprio_class -n ioprio_classdata] =
<path>|<device>=0A=
        Resume previously canceled or interrupted scrub=0A=
    btrfs scrub status [-dR] <path>|<device>=0A=
        Show status of running or finished scrub=0A=
=0A=
    btrfs check [options] <device>=0A=
        Check structural integrity of a filesystem (unmounted).=0A=
=0A=
    btrfs rescue chunk-recover [options] <device>=0A=
        Recover the chunk tree by scanning the devices one by one.=0A=
    btrfs rescue super-recover [options] <device>=0A=
        Recover bad superblocks from good copies=0A=
    btrfs rescue zero-log <device>=0A=
        Clear the tree log. Usable if it's corrupted and prevents mount.=0A=
=0A=
    btrfs restore [options] <device> <path> | -l <device>=0A=
        Try to restore files from a damaged filesystem (unmounted)=0A=
=0A=
    btrfs inspect-internal inode-resolve [-v] <inode> <path>=0A=
        Get file system paths for the given inode=0A=
    btrfs inspect-internal logical-resolve [-Pv] [-s bufsize] <logical> =
<path>=0A=
        Get file system paths for the given logical address=0A=
    btrfs inspect-internal subvolid-resolve <subvolid> <path>=0A=
        Get file system paths for the given subvolume ID.=0A=
    btrfs inspect-internal rootid <path>=0A=
        Get tree ID of the containing subvolume of path.=0A=
    btrfs inspect-internal min-dev-size [options] <path>=0A=
        Get the minimum size the device can be shrunk to. The=0A=
    btrfs inspect-internal dump-tree [options] device=0A=
        Dump tree structures from a given device=0A=
    btrfs inspect-internal dump-super [options] device [device...]=0A=
        Dump superblock from a device in a textual form=0A=
    btrfs inspect-internal tree-stats [options] <device>=0A=
        Print various stats for trees=0A=
=0A=
    btrfs property get [-t <type>] <object> [<name>]=0A=
        Gets a property from a btrfs object.=0A=
    btrfs property set [-t <type>] <object> <name> <value>=0A=
        Sets a property on a btrfs object.=0A=
    btrfs property list [-t <type>] <object>=0A=
        Lists available properties with their descriptions for the given =
object.=0A=
=0A=
    btrfs send [-ve] [-p <parent>] [-c <clone-src>] [-f <outfile>] =
<subvol> [<subvol>...]=0A=
        Send the subvolume(s) to stdout.=0A=
    btrfs receive [-ve] [-f <infile>] [--max-errors <N>] <mount>=0A=
        Receive subvolumes from stdin.=0A=
=0A=
    btrfs quota enable <path>=0A=
        Enable subvolume quota support for a filesystem.=0A=
    btrfs quota disable <path>=0A=
        Disable subvolume quota support for a filesystem.=0A=
    btrfs quota rescan [-sw] <path>=0A=
        Trash all qgroup numbers and scan the metadata again with the =
current config.=0A=
=0A=
    btrfs qgroup assign [options] <src> <dst> <path>=0A=
        Assign SRC as the child qgroup of DST=0A=
    btrfs qgroup remove <src> <dst> <path>=0A=
        Remove a child qgroup SRC from DST.=0A=
    btrfs qgroup create <qgroupid> <path>=0A=
        Create a subvolume quota group.=0A=
    btrfs qgroup destroy <qgroupid> <path>=0A=
        Destroy a quota group.=0A=
    btrfs qgroup show -pcreFf =
[--sort=3Dqgroupid,rfer,excl,max_rfer,max_excl] <path>=0A=
        Show subvolume quota groups.=0A=
    btrfs qgroup limit [options] <size>|none [<qgroupid>] <path>=0A=
        Set the limits a subvolume quota group.=0A=
=0A=
    btrfs replace start [-Bfr] <srcdev>|<devid> <targetdev> <mount_point>=0A=
        Replace device of a btrfs filesystem.=0A=
    btrfs replace status [-1] <mount_point>=0A=
        Print status and progress information of a running device replace=0A=
    btrfs replace cancel <mount_point>=0A=
        Cancel a running device replace operation.=0A=
=0A=
    btrfs help [--full]=0A=
        Display help information=0A=
    btrfs version=0A=
        Display btrfs-progs version=0A=
=0A=
Use --help as an argument for information on a specific group or command.=0A=

------=_NextPart_000_0032_01D3DFA8.977EB680--

