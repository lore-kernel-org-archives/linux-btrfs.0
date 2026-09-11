Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C677A38A702
	for <linux-btrfs@vger.kernel.org>; Fri, 11 Sep 2026 23:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789170154; cv=none; b=XHbs6NeR4EMRH0BLez6GBlst5J2npMelVXgy9876LBF3m89HJU6NUtVleBDjI/XEj+2fr4iWlcNAK29x0QAIiFfBffrzFbth0ik3cpvrUwqbHgAbtzqgZMO3hn+XZ5eT2+NaORyq98BXp3oCprZ7msdbhCyOWceQLb6YMaz6vYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789170154; c=relaxed/simple;
	bh=6NQ0oyWzgQ+Y8mp8hdn/95wATMDMQT81Vzu7o8ij3Ao=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RFVXtlQBGb2/W/943+F4XSVzSv4mHuNINUUO8q6SlezY4n4/11J5l57BD5s0rxbFigjHE5FeewDAFkqlC/2kv31oJzW0V/04ptTtQnXBH8lcY2TDV9VySwR4i5m7rhGobCPb6RRKc82nZgMfdaIqtTqA90Salw5NtEGkPLsvhmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=PjNP1F4l; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="PjNP1F4l"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c20ce3c118aso183856566b.0
        for <linux-btrfs@vger.kernel.org>; Fri, 11 Sep 2026 16:42:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1789170150; x=1789774950; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2Ofwz1tSwH1NQdwiq8BEkuuNnYnRc7CDqbFW6Xu+SUs=;
        b=PjNP1F4ls+iqKH45ZsDYXP7tdtqufkyE3fjX05J8IYoySO0jAndSO7InfLjJ2h8DlF
         D88Gbr58KJ3f2IDJwM0xKyVfGfIh+ffGcrMI/eEQLiKSZPTmwfoPDz2VW/nF/JAOjrpB
         B7QQxQZuYuDCqG8HDrXZdq3G39BGYBGJYLa+gGTsNU6xjQOvMKg0qnkizt7vEF19Kk4+
         36TwM2nR4MPdMltnyu0yEDkRmwd6uQtwRIDsuxO6dvEIpdrTbFjltJ95LU5UXYckh4z3
         FHCWkiVVUIG1QdANrlnvTuQWapzw4orz1CCxMNcAAK0rbQkQ4CRu4cLr89mcjCG2Bx3w
         vOyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789170150; x=1789774950;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2Ofwz1tSwH1NQdwiq8BEkuuNnYnRc7CDqbFW6Xu+SUs=;
        b=OmhPySxnoA/XUgUfmSJVe52EzIvKbs7GtZjW/ctyaO6/btLHrJOozXo9YgzXw+z/b+
         WbtmWLTY0wK19iC62e2txOrjtEqtjzJfsaV3hwgOnJyDLNvRK0vmucO5a5zjEeHbAk6g
         f0oQXCUEr93XuLQgFB+EfrGXI3kFgnTu9XJ9ZwaAniRYwYjjYpfmxc1kX681zqmgBIAK
         M6b8H2N0fhDeJZmvjr/ZdqB4oDb6S7VsVPEmI76+cd9yv26UIWtwa36UXO8cIS8hKiEV
         e1awobYFF0VCWNHcL2/T8Z/yIIvXfNtT7xE7M/l2ZFIPdsMKOeMtrkdVI29f/jR3xdC7
         y68Q==
X-Forwarded-Encrypted: i=1; AKwUvByDiwdTW0UsNkWBUVXLuNhG7YYmIj742yJ0Ra0HmCqaEA0b0rd9hb8wQn0tPFRDWV2Ms3zNr7LFB8Ry/A==@vger.kernel.org
X-Gm-Message-State: AFuF++llj9etk/CpKohCW2rC01TJTSbkYECdvtg3QyBTEo3SFgZ80EBe
	2wv3CNuCEtfXEldaUfTrklgpBNFnK99NGuITc66VsNU7PpnvgojiJCgkNKTTl36YzXiCsx0HHe8
	IKUXdpujy8w==
X-Gm-Gg: AYBFou177fkb8+M/xZiDonovSpx2EOnQOSMsQQCppYGTMLtENLHVXNJnmw0dQmmNspv
	bAozxsfbKmR/Ir1IGRcq+XvdtvdgZCPVM+nHqmvbwopYrSbH0h4t8xY6g1PcqWJEdRxmk6YLF+t
	eLL08Gv6sszvnILYG1WD+/c49eJyKsFMgPjcRkT9mroSmczH/xtmx7k9pnTrn2zgCq6e4h35Jag
	L5yQkz5FLjplKU1rIFe58tquMSvcTRcpOrMxflvwXfsNnfhR+TRWtszV5VoRySWRdG23DS3Jv74
	ixAUoacnKP7upiRHI5rOLpacBuMFZDlGcw/AAmfgxf2cDyVCiukiTEFDDwoXbVGgcFwb6Md3boP
	ZubAx67Vwuw7WyUGkQfC2QDJ+yyXB0YsJQWHtJkt0IOnfOvVV2eRNDpfau1Uitew//nCxZhMV2a
	1e4+Asd9lMwAMqM79vkvzaU+Am/ZAVA6kuDelzt9wPYRvXtQj78Cqi4sioGLdaB8o=
X-Received: by 2002:a17:907:7ba9:b0:c29:42ad:acd0 with SMTP id a640c23a62f3a-c2945f702cfmr609056866b.30.1789170149804;
        Fri, 11 Sep 2026 16:42:29 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dd2cffb5c5sm17053395ad.80.2026.09.11.16.42.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Sep 2026 16:42:28 -0700 (PDT)
Message-ID: <8cf9fc40-3316-44c0-bf8e-bd8698a50a33@suse.com>
Date: Sat, 12 Sep 2026 09:12:20 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: commit 108cc873398932af589c295f78c348513b8d70d9 breaks
 update-grub on btrfs root filesystem
To: Alex Romosan <aromosan@gmail.com>, dsterba@suse.cz
Cc: Thorsten Leemhuis <regressions@leemhuis.info>,
 Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-kernel@vger.kernel.org,
 linux-btrfs <linux-btrfs@vger.kernel.org>,
 Linux kernel regressions list <regressions@lists.linux.dev>
References: <CAKLYgeL7nrA4nXcewdv9Fqg_s=3GS=vmoypnEiZBKQ7rySZFuQ@mail.gmail.com>
 <20260909002506.GF9053@twin.jikos.cz>
 <6a5c2d41-b10b-44cb-969e-b4a56d002ceb@gmx.com>
 <4c5117f7-1ddd-4596-8917-da47379506fd@leemhuis.info>
 <20260911182125.GE54722@twin.jikos.cz>
 <CAKLYgeLAXC5qbNAWnS3KNCijuRT9mF_hz4e1fUexx+D-J5Bs4g@mail.gmail.com>
Content-Language: en-US
From: Qu Wenruo <wqu@suse.com>
Autocrypt: addr=wqu@suse.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNGFF1IFdlbnJ1byA8d3F1QHN1c2UuY29tPsLAlAQTAQgAPgIbAwULCQgHAgYVCAkKCwIE
 FgIDAQIeAQIXgBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJnEXVgBQkQ/lqxAAoJEMI9kfOh
 Jf6o+jIH/2KhFmyOw4XWAYbnnijuYqb/obGae8HhcJO2KIGcxbsinK+KQFTSZnkFxnbsQ+VY
 fvtWBHGt8WfHcNmfjdejmy9si2jyy8smQV2jiB60a8iqQXGmsrkuR+AM2V360oEbMF3gVvim
 2VSX2IiW9KERuhifjseNV1HLk0SHw5NnXiWh1THTqtvFFY+CwnLN2GqiMaSLF6gATW05/sEd
 V17MdI1z4+WSk7D57FlLjp50F3ow2WJtXwG8yG8d6S40dytZpH9iFuk12Sbg7lrtQxPPOIEU
 rpmZLfCNJJoZj603613w/M8EiZw6MohzikTWcFc55RLYJPBWQ+9puZtx1DopW2jOwE0EWdWB
 rwEIAKpT62HgSzL9zwGe+WIUCMB+nOEjXAfvoUPUwk+YCEDcOdfkkM5FyBoJs8TCEuPXGXBO
 Cl5P5B8OYYnkHkGWutAVlUTV8KESOIm/KJIA7jJA+Ss9VhMjtePfgWexw+P8itFRSRrrwyUf
 E+0WcAevblUi45LjWWZgpg3A80tHP0iToOZ5MbdYk7YFBE29cDSleskfV80ZKxFv6koQocq0
 vXzTfHvXNDELAuH7Ms/WJcdUzmPyBf3Oq6mKBBH8J6XZc9LjjNZwNbyvsHSrV5bgmu/THX2n
 g/3be+iqf6OggCiy3I1NSMJ5KtR0q2H2Nx2Vqb1fYPOID8McMV9Ll6rh8S8AEQEAAcLAfAQY
 AQgAJgIbDBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJnEXWBBQkQ/lrSAAoJEMI9kfOhJf6o
 cakH+QHwDszsoYvmrNq36MFGgvAHRjdlrHRBa4A1V1kzd4kOUokongcrOOgHY9yfglcvZqlJ
 qfa4l+1oxs1BvCi29psteQTtw+memmcGruKi+YHD7793zNCMtAtYidDmQ2pWaLfqSaryjlzR
 /3tBWMyvIeWZKURnZbBzWRREB7iWxEbZ014B3gICqZPDRwwitHpH8Om3eZr7ygZck6bBa4MU
 o1XgbZcspyCGqu1xF/bMAY2iCDcq6ULKQceuKkbeQ8qxvt9hVxJC2W3lHq8dlK1pkHPDg9wO
 JoAXek8MF37R8gpLoGWl41FIUb3hFiu3zhDDvslYM4BmzI18QgQTQnotJH8=
In-Reply-To: <CAKLYgeLAXC5qbNAWnS3KNCijuRT9mF_hz4e1fUexx+D-J5Bs4g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/9/12 04:20, Alex Romosan 写道:
> i agree it's a regression. one question (and i am not very familiar
> with the underlying principles), how do the other filesystems deal
> with this? shouldn't the registering of devices be abstracted out
> since i would assume every fs does it or is this something btrfs
> specific?

Other fses has the same problem on the reported device path.

The difference is other fses saves the device path at mount time and 
doesn't change.

E.g, the same weird device path can be utilized and reported for other 
fses too:

  # cd /dev/
  # mknod weird b 253 2
                  ^^^^^ The same major/minor number for
                        /dev/test/scratch1
  # mkfs.ext4 /dev/weird -F
  # mount /dev/weird /mnt/test
  # mount | tail - n1
  /dev/weird on /mnt/test type ext4 (rw,relatime)

The btrfs specific part is, btrfs can rename the device path on device 
rescan.

That introduced a new problem, should we trust the device path passed in 
for scan?

Normally a device scan is triggered by udev rules, so normally it's sane 
names like "/dev/sda1".
But end users can easily pass random/weird pass in that ioctl to force 
an update on device path, and we're back to the start point.

Furthermore when LVM gets involved, the same dm device can have multiple 
different softlinks.
And a wrong softlink scanned can easily screw a lot of mount detection, 
aka, screw up the most common tool we use, fstests.

Then we can easily have a weird situation where the same device is 
scanned again and again with different names (e.g. "/dev/dm-2" and 
"/dev/test/scratch1"), causing btrfs to report different device name 
depending on the timing.


Another situation is, someone is passing a completely weird name, which 
may not even be accessible by other processes.
The worst situation here is "/proc/self/fd/3", which can be a softlink 
to a block device, but only accessible by that exact process.


One solution to this complex corner case is, to do a proper path 
resolution, and check if the existing recorded path can be accessible, 
if not replace it with the newer one.

However that is not perfect either, firstly related to namespace, the 
device scan can be triggered inside a namespace, and again the path can 
only be accessible inside a certain namespace.

Secondly such path resolution may involve btrfs itself, e.g. the block 
file is not in devfs, but a directory inside btrfs.
Then scan and path resolution may lock the same inode, causing deadlock.

All the history can be found in this patch:

https://lore.kernel.org/linux-btrfs/5e65d9ba5927b4b6985ce819e9e49d082c6e9b45.1789112424.git.wqu@suse.com/T/#u


Now back to the grub problem, firstly it's not causing anyone unable to 
boot, it is only causing the grub2-probe unable to determine where the 
device is.

The reason is for users who are not using initramfs, but direct kernel 
boot. In that case, the rootfs is always using the name "/dev/root".

The lack of initramfs means we do not have proper devfs at boot time, so 
kernel is using that "/dev/root" for rootfs.

But after the system is fully up, a proper devfs is mounted at "/dev/", 
so the older temporary "/dev/root" is no longer accessible.

I can argue that the user space should not really trust the device path 
reported by mount, but utilize the device number reported for the mount 
point. E.g "mountpoint -d", then go through the "/dev/" or libblkid to 
grab the real device.

In fact, even using that weird name, other tools like lsblk can properly 
detect the real device without being confused by the name:

|-test-scratch1 253:2    0   10G  0 lvm  /mnt/test

> 
> On Fri, Sep 11, 2026 at 8:21 PM David Sterba <dsterba@suse.cz> wrote:
>>
>> On Thu, Sep 10, 2026 at 12:39:25PM +0200, Thorsten Leemhuis wrote:
>>> On 9/9/26 03:13, Qu Wenruo wrote:
>>>> 在 2026/9/9 09:55, David Sterba 写道:
>>>>> On Tue, Sep 08, 2026 at 11:59:43PM +0200, Alex Romosan wrote:
>>>>>>
>>>>>> [...] Since version 7.3-rc1 i haven't been able to to a grub-update,
>>>>>> instead i get this error:
>>>>>>
>>>>>> /usr/sbin/grub-probe: error: cannot find a device for / (is /dev
>>>>>> mounted?).
>>>>>>
>>>>>> 7.2 is fine. a git-bisect identified commit
>>>>>> 108cc873398932af589c295f78c348513b8d70d9 as being the culprit.
>>>>>> reverting this commit from 7.3-rc2 allowed me to run grub-update
>>>>>> again.
>>>>>>
>>>>>> this is not the first time i reported grub-update being broken on
>>>>>> btrfs. i reported exactly the same problem on jan 8, 2024
>>>>>> (https://lkml.iu.edu/hypermail/linux/kernel/2401.1/00596.html). maybe
>>>>>> the discussion that followed would help come up with a fix that will
>>>>>> make everybody happy.
>>>>>
>>>>> I remember debugging that one, https://bugzilla.kernel.org/
>>>>> show_bug.cgi?id=218353
>>>>> Reverting 108cc8733989 ("btrfs: fix a lockdep caused by path resolution
>>>>> during device scan") would bring back the lockdep warning and there is a
>>>>> locking problem.
>>>>>
>>>>> The commit says it's fixing 2e8b6bc0ab41 ("btrfs: avoid unnecessary
>>>>> device path update for the same device"), the difference is in lines
>>>>>
>>>>> (https://bugzilla.suse.com/show_bug.cgi?id=1230641)
>>>>>
>>>>> -       } else if (!device->name || strcmp(device->name->str, path)) {
>>>>> +    } else if (!device->name || !is_same_device(device, path)) {
>>>>>
>>>>> Which gets changed to (by 108cc8733989):
>>>>>
>>>>> -       } else if (!device->name || !is_same_device(device, path)) {
>>>>> +       } else if (!device->name || device->devt != path_devt) {
>>>>>
>>>>> Each change is reaction to a bug, I don't see a clear fix which will
>>>>> make it work in all cases.
>>>>
>>>> And I want to add that, the previous path based comparison is also
>>>> problematic for namespaces/weird block device names.
>>>>
>>>> Although not common, it's definitely possible to map weird block file
>>>> name into a namespace.
>>>>
>>>> Thus the path based comparison is not reliable in the first place, no to
>>>> mention the later lockdep problems.
>>>
>>> Well, but our #1 is "no regressions". And the recent change while fixing
>>> bugs clearly causes one, as Alex's report is afaics at least the third
>>> about it; the two earlier ones can be found here:
>>>
>>> https://lore.kernel.org/linux-btrfs/dfbe1e27-dab8-4d55-8cf3-0b28eeac5df4@gmail.com/
>>> https://lore.kernel.org/linux-btrfs/018a9738-1d4a-43a0-9352-a56d1e541364@gmail.com/
>>> Plus a repost of the latter here:
>>> https://lore.kernel.org/linux-btrfs/dfbe1e27-dab8-4d55-8cf3-0b28eeac5df4@gmail.com/
>>
>> I'm going to treat this as a regression. And for the record Qu and me
>> are in disagreement on that. My target is to make the systems boot again
>> first, the fix may leave some problematic case (like mentioned, devices
>> in namespaces), but that is probably a lesser problem.

It's not not-booting, but just grub2-probe unable to determine which 
device it really has, and so far only affects users without a initramfs.

But if you really want to revert back to fix this particular case, then 
allow the old bad random device rename, back to the starting point of 
the cat-mice game:


diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 4ddabadc9188..f4b36ad1282d 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -749,6 +749,18 @@ const u8 *btrfs_sb_fsid_ptr(const struct 
btrfs_super_block *sb)
         return has_metadata_uuid ? sb->metadata_uuid : sb->fsid;
  }

+static int device_name_cmp(struct btrfs_device *device, const char *path)
+{
+       const char *old_name;
+       int ret;
+
+       rcu_read_lock();
+       old_name = rcu_dereference(device->name);
+       ret = strcmp(old_name, path);
+       rcu_read_unlock();
+       return ret;
+}
+
  /*
   * Add new device to list of registered devices
   *
@@ -869,7 +881,7 @@ static noinline struct btrfs_device 
*device_list_add(const char *path,
                                 MAJOR(path_devt), MINOR(path_devt),
                                 current->comm, task_pid_nr(current));

-       } else if (!device->name || device->devt != path_devt) {
+       } else if (!device->name || device_name_cmp(device, path)) {
                 const char *old_name;

                 /*
