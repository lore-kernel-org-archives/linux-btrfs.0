Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:57946 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753724Ab3BZTLn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Feb 2013 14:11:43 -0500
Received: by mail-wg0-f45.google.com with SMTP id dq12so3629397wgb.0
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Feb 2013 11:11:42 -0800 (PST)
Message-ID: <512D092F.5040003@gmail.com>
Date: Tue, 26 Feb 2013 20:12:47 +0100
From: Goffredo Baroncelli <kreijack@gmail.com>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Martin Steigerwald <Martin@lichtvoll.de>
CC: linux-btrfs@vger.kernel.org, Tsutomu Itoh <t-itoh@jp.fujitsu.com>,
        Eric Sandeen <sandeen@redhat.com>, chris.mason@fusionio.com,
        Stefan Behrens <sbehrens@giantdisaster.de>,
        David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH, RFC] btrfs-progs: require mkfs -f force option to overwrite
 filesystem or partition table
References: <511D2D2B.8040804@redhat.com> <512BFCD1.3030709@redhat.com> <512C3230.8020305@jp.fujitsu.com> (sfid-20130226_100038_658757_45BCF698) <201302261137.46319.Martin@lichtvoll.de>
In-Reply-To: <201302261137.46319.Martin@lichtvoll.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/26/2013 11:37 AM, Martin Steigerwald wrote:
> Am Dienstag, 26. Februar 2013 schrieb Tsutomu Itoh:
>>>> Therefore I want you to revert
>>>> commit:2a2d8e1962e8b6cda7b0a7584f6d2fb95d442cb6.
>>>>
>>>>    btrfs-progs: require mkfs -f force option to overwrite filesystem
>>>> or partition table
>>>>
>>>> How do you think about it?
>>>
>>> What if you submit a patch to look at an environment variable,
>>> BTRFS_CLOBBERS_ALL=1 which causes it to not require -f to overwrite?
>>> Then you can just set it once at the top of your test environment,
>>> and not change every instance?
>>
>> Yes. But,
>>  >> (Most of my test scripts fails without -f. So I'll always type
>> "mkfs.btrfs -f") is one example.
>>
>> Almost everyone types "mkfs.btrfs -f" (or BTRFS_CLOBBERS_ALL=1 :)
>> unconditionally, I think.
>> So, I think -f option is almost meaningless.
> 
> No.
> 
> I don´t.

me too

> 
> And I teach not to in my trainings as well.
> 
> Everyone who uses rm -rf by default even just for deleting a single file does 
> it as long as he or she deleted his / her home directory or something.

Unfortunately the "rm -rf" is a different case. Removing a directory is
a common case. We should not be forced to use the -f for common case. A
'-f' flag should be used only in "uncommon" case (like *re*format a disk
or a test-suite)...

However I think that '-f' is good for mkfs.btrfs.


> 
> Ciao,


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
