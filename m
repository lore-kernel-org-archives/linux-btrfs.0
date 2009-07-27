From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
Subject: Re: BTRFS file clone support for cp
Date: Tue, 28 Jul 2009 00:40:14 +0100
Message-ID: <4A6E3ADE.6050008@draigBrady.com>
References: <87d47o3fip.fsf@master.homenet>
	<4A6CEA48.5050208@draigBrady.com>	<8763defuvq.fsf@meyering.net>
	<87ws5tvrq8.fsf@master.homenet>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Cc: bug-coreutils@gnu.org, Jim Meyering <jim@meyering.net>,
	linux-btrfs@vger.kernel.org
To: Giuseppe Scrivano <gscrivano@gnu.org>
Return-path: <bug-coreutils-bounces+gcgcb-bug-coreutils-616=gmane.org@gnu.org>
In-Reply-To: <87ws5tvrq8.fsf@master.homenet>
List-Unsubscribe: <http://lists.gnu.org/mailman/listinfo/bug-coreutils>,
	<mailto:bug-coreutils-request@gnu.org?subject=unsubscribe>
List-Archive: <http://lists.gnu.org/pipermail/bug-coreutils>
List-Post: <mailto:bug-coreutils@gnu.org>
List-Help: <mailto:bug-coreutils-request@gnu.org?subject=help>
List-Subscribe: <http://lists.gnu.org/mailman/listinfo/bug-coreutils>,
	<mailto:bug-coreutils-request@gnu.org?subject=subscribe>
Errors-To: bug-coreutils-bounces+gcgcb-bug-coreutils-616=gmane.org@gnu.org
List-ID: <linux-btrfs.vger.kernel.org>

Giuseppe Scrivano wrote:
> Jim Meyering <jim@meyering.net> writes:
>=20
>>> Another possible issue with this I can think of is
>>> depending on the modification pattern of the COW files,
>>> the modification processes could fragment the file or
>>> more seriously be given ENOSPC errors.
>> I hope btrfs takes care of this behind the scene.
>>
>> How does the clone work wrt to space consumed, a la df?
>> If copying a 1GB file this way does not update usage
>> stats to reflect the additional 1GB of space used, ...
>=20
> I tried to clone a big file and df reported a different "used blocks"
> stat that it was before the clone operation.

How different exactly?
OK I tried this myself on F11 with inconclusive results.

$ uname -r
2.6.29.6-213.fc11.i586
$ sudo yum install btrfs-progs
# dd bs=3D1M count=3D300 if=3D/dev/zero of=3D/btrfs.img #min size?
# mkfs.btrfs /btrfs.img
# mkdir /btrfs
# mount -o loop /btrfs.img /btrfs
# cd /btrfs
# dd bs=3D1M count=3D100 if=3D/dev/zero of=3Dalloc.test
# df -h .
Filesystem            Size  Used Avail Use% Mounted on
/dev/loop0            300M   28K  300M   1% /btrfs
# df -h . #only allocated about 30s later
Filesystem            Size  Used Avail Use% Mounted on
/dev/loop0            300M  101M  200M  34% /btrfs
# /home/padraig/clone_file alloc.test alloc.test.clone
# umount /btrfs
# mount -o loop /btrfs.img /btrfs
# cd btrfs
# df -h .
Filesystem            Size  Used Avail Use% Mounted on
/dev/loop0            300M  101M  200M  34% /btrfs

OK the above suggests that the clone doesn't take
any space as I would expect. Then it starts getting confusing...

# du -h *
100M    alloc.test
244M    alloc.test.clone #wha?
# dd bs=3D1M count=3D200 if=3D/dev/zero of=3Duse.space
dd: writing `use.space': No space left on device
101+0 records in
100+0 records out
# ls -l
total 454656
-rw-r--r-- 1 root root 104857600 2009-07-28 00:06 alloc.test
-rw-r--r-- 1 root root 104857600 2009-07-28 00:07 alloc.test.clone
-rw-r--r-- 1 root root 104857600 2009-07-28 00:18 use.space
# df -h .
Filesystem            Size  Used Avail Use% Mounted on
/dev/loop0            300M  184M  117M  62% /btrfs

The above suggests that the clone does actually allocate space
but btrfs isn't reporting it through statvfs correctly?
If the clone does allocate space, then how can one
clone without allocation which could be very useful
for snapshotting for example?

Also I tried the above twice and both times got:
http://www.kerneloops.org/submitresult.php?number=3D578993

cheers,
P=E1draig.
