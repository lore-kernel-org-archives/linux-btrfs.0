Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51594 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753341AbcIUNuQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Sep 2016 09:50:16 -0400
Subject: Re: Experimental btrfs encryption
To: Chris Mason <clm@fb.com>
References: <20160919151518.i2aon4axmfzt54rn@thunk.org>
 <nrpjhc$g72$3@blaine.gmane.org> <a8dc3c28-5629-d870-f202-de35d2f941f1@fb.com>
 <20160920025041.mzeljxxzclikktxn@thunk.org>
 <12484cc6-b5ca-e507-157e-5eb48d9a4edf@fb.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Alex Elsayed <eternaleye@gmail.com>,
        linux-btrfs@vger.kernel.org
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <eaca18c1-9022-9705-a8e5-1ccac9b39c22@oracle.com>
Date: Wed, 21 Sep 2016 21:52:04 +0800
MIME-Version: 1.0
In-Reply-To: <12484cc6-b5ca-e507-157e-5eb48d9a4edf@fb.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



> So there's a matrix of possible configurations.  If you're doing a
> reflink between subvolumes and you're doing a subvolume granular
> encryption and you don't have keys to the source subvolume, the reflink
> shouldn't be allowed.

  Right, this is working.

> If you do have keys, any new writes are happening
> into a different inode, and will be encrypted with a different key.

  As of now it returns -EXDEV. But I should change this.

> If you're doing a file level encryption and you do have access to the
> source file, the destination file is a new inode.  Thanks to COW any
> changes are going to go into new extents and will end up with different
> keys/nonces.

> Either way, we degrade down into extent based encryption.  I'd take that
> hit to maintain sane semantics in the face of snapshots and reflinks.
> The btrfs extent structures on disk already have an encryption type field.

  Agreed. About keys.. a file might need N number of keys (N = number of
  extents) to open.

Thanks, Anand


>>
>> So in any case, assuming you're using block encryption (which is what
>> fscrypt uses) there really isn't a problem with nonce reuse, although
>> in some cases if you really do want to reflink a file and have it be
>> protected by different user keys, this would have to force copy of the
>> duplicated blocks at that point.  But arguably, that is a feature, not
>> a bug.  If the two users are mutually suspicious, you don't _want_ to
>> leak information about who much of a particular file had been changed
>> by a particular user.  So you would want to break the reflink and have
>> separate copies for both users anyway.
>>
>>
>> One final thought --- something which is really going to be a factor
>> in many use cases is going to be hardware accelerated encryption.  For
>> example, Qualcomm is already shipping an SOC where the encryption can
>> be done in the data path between the CPU and the eMMC storage device.
>> If you want to support certain applications that try to read megabytes
>> and megabytes of data before painting a single pixel, in-line hardware
>> crypto at line speeds is going to be critical if you don't want to
>> sacrifice performance, and keep users from being cranky because it
>> took extra seconds before they could start reading their news feed (or
>> saving bird eggs from voracious porcine predators, or whatever).
>>
>> This may very well be an issue in the future not just for mobile
>> devices, but I could imagine this potentially being an issue for other
>> form factors as well.  Yes, Skylake can encrypt multiple bytes per
>> clock cycle using the miracles of hardware acceleration and
>> pipelining.  But in-line encryption will still have the advantage of
>> avoiding the memory bandwidth costs.  So while it is fun to talk about
>> exotic encryption modes, it would be wise to have file system
>> encryption architectures to have modes which are compatible with
>> hardware in-line encryption schemes.
>>
>
> Strongly agree here.  This is the whole reason btrfs used crc32c, but
> times 100 (or maybe 1000).  I love that  Kent and others are
> experimenting in bcachefs and elsewhere.  Btrfs can always bring in new
> schemes that work well once the framework is in place, but its not an
> area where I have enough expertise to get exotic on the first try.
>
> -chris
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
