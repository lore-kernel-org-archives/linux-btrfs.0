From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH] 254: disable space cache
Date: Mon, 21 Nov 2011 10:42:04 +0800
Message-ID: <4EC9BA7C.20907@cn.fujitsu.com>
References: <4EC61AC3.6010806@cn.fujitsu.com> <4EC9AD92.6020000@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EC9AD92.6020000@jp.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hidetoshi Seto wrote:
> (2011/11/18 17:43), Li Zefan wrote:
>> I can't pass 254, and below is the output:
>>
>> 254 3s ... - output mismatch (see 254.out.bad)
>> ...
>>  ID 256 top level 5 path snap
>> -ID 257 top level 5 path subvol
>> +ID 258 top level 5 path subvol
>>
>> When space cache is enabled (and now mkfs.btrfs always enables it),
>> there will be some space cache inodes in the root tree, and they
>> consume some IDs, and that's why "subvol" has the ID 258 but not 257.
>>
>> Just disable space cache for this test case.
>>
>> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
>> ---
>>  254 |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/254 b/254
>> index 5216120..1cd4832 100755
>> --- a/254
>> +++ b/254
>> @@ -48,7 +48,7 @@ _supported_os Linux
>>  _require_scratch
>>  
>>  _scratch_mkfs > /dev/null 2>&1
>> -_scratch_mount
>> +_scratch_mount -o nospace_cache
>>  
>>  # First test basic snapshotting
>>  echo "Creating file foo in root dir"
> 
> I got following error on fedora 16 with your patch:
> 

This is an alternative fix:

========================

[PATCH] 254: avoid output mismatch due to space cache

I can't pass 254, and below is the output:

254 3s ... - output mismatch (see 254.out.bad)
...
 ID 256 top level 5 path snap
-ID 257 top level 5 path subvol
+ID 258 top level 5 path subvol

When space cache is enabled (and now mkfs.btrfs always enables it),
there will be some space cache inodes in the root tree, and they
consume some IDs, and that's why "subvol" has the ID 258 but not 257.

Just list subvolume names, don't assume what ID numbers those subvolumes
will have.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 254     |    2 +-
 254.out |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/254 b/254
index 5216120..7b74a02 100755
--- a/254
+++ b/254
@@ -95,7 +95,7 @@ ls $SCRATCH_MNT
 
 # Test listing the subvolumes
 echo "Listing subvolumes"
-btrfs subvolume list $SCRATCH_MNT | _filter_scratch
+btrfs subvolume list $SCRATCH_MNT | awk '{ print $NF }'
 
 # Delete the snapshot
 btrfs subvolume delete $SCRATCH_MNT/snap | _filter_scratch
diff --git a/254.out b/254.out
index 582357a..d4b5346 100644
--- a/254.out
+++ b/254.out
@@ -31,8 +31,8 @@ List root dir
 snap
 subvol
 Listing subvolumes
-ID 256 top level 5 path snap
-ID 257 top level 5 path subvol
+snap
+subvol
 Delete subvolume 'SCRATCH_MNT/snap'
 List root dir
 subvol
-- 
1.7.3.1

