Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57FE13E2767
	for <linux-btrfs@vger.kernel.org>; Thu, 16 Apr 2026 15:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776352908; cv=none; b=CHg1Tz53cfAN+EkdXbGiwseEo+ehW6R/ZKpgkJbgCvXEaEj5tTTrpH3WP0BcOlQIfh333RlaQUWsRFamCOpK0WkKYTSCbt6UFYWvwSjhG+HhrzR1PLUhyHrBN/udjfsprydcySUHM/vRAkjGpZRdww2lBTJw/ymmuz2jU5BOPRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776352908; c=relaxed/simple;
	bh=tRMmlzxvSX4htYuEHCnPs/qYReuyqniRG4vNY3fWEME=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=vClsximcl0jZBLk4dE4qqR7ov50KYu4uNJhQR8iny//KqzXrPsML9uOwD2YEmu8C29ulf3avzBR2HBXg5JaLOewtOAE/ZrlxC3XV5N729Q7m1wARzh4RJRrEXl4wxNANyjBfRI/txLxSlun7DJIrN/Zgpe462kCtfgVDb5Z3pPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XrZLPyL4; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XrZLPyL4"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2b24fcc2b5dso55138825ad.1
        for <linux-btrfs@vger.kernel.org>; Thu, 16 Apr 2026 08:21:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776352906; x=1776957706; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kQW1GsyE5hA61Va8D6UzmdjO7IhbJJ2/YT9xpWvxTgw=;
        b=XrZLPyL4fI1ShvLs8KDuZaIWdVnzv/9dSzITtZ8aVMmdqiX50nae8FxZrNyx5WAtDU
         JpzkoHH1kStMFeQuP1w5zvmjdO1Qbnn41XVvzJXcXNLqcdHxwNl391mIyhnIXcwXz2YX
         dtYPDr2yzTEzHl44xLZGQFkqmOL4Cv9uHLc8SrthyR96tIesLsQETMs5e9Mlx/uf6Oqo
         o1N5GQXQe1IYPh4t1gkFO0JZkWHd3TZ9VGt6KVhHapzh9iTKSLqvDTnxv3O70uCupPWF
         hOd73FRh/qVeGoNjl4CxphG/3/mLpC3dNnRBhMmKT3hroNaDHse3JgkawwOvRLsMCmcX
         r8hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776352906; x=1776957706;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kQW1GsyE5hA61Va8D6UzmdjO7IhbJJ2/YT9xpWvxTgw=;
        b=S+Mb3926pubLoXs1qnXua2S5hYCrf9EUIE2Gaykpunhj6mF1rIy2h0XKUN/3byoIP/
         CoCPGj9RP4zECoj3YDgf/rwXX9K00kjVXILB7w4wE/diigLpG+/U4GS3YgttIrGhxdoP
         x1Uuo6HmhZA3nZ+GSNs1391CG/hRV1MS/3lS1iHFQkeM61Kzon/jAU7e5JQE9m9Gncxm
         wH32cEo7EKiU5khFX8zc2mC3i9vDK6dlauoV4+6+Y+SONvIyWSV8AZDgo2oNIBegx6uy
         7A9DzxoaH4XcPU0FvxE1U/H/iYEoG7FIL+qRUl3JJWRKVTdD9yt6caayPKRt9mTq4Tcz
         Zr0w==
X-Forwarded-Encrypted: i=1; AFNElJ+ZAgDuRM4MOLeO4cW87AukzgpuMTXh9JmvrSfu9pRSm3mQofxZBFsug/QS+FEjQY0jjI0U5y7tMsVVOQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxWmYDqA1tN4mnrj1iAO8zMjDBV9/Z9L5O1O/A0fxs7EMZEUlnz
	WIq1mFQAPC/YASRH0HL2v8biJibdxDaXzJKoJwqB1NyRRzmDTK396cBO
X-Gm-Gg: AeBDiesjv96ap4RGJX/xknvtSJSZojtHYU9cqukelcemXeZnDTsWa4q2joLIf9dLJ9P
	a6eqAknK1zIV9XgJWtJeB+J9KtNuosolex0UuzN+nhLA2GsTMzR2oqfq18RwH0GXpZJGaMYnZBn
	mn+y9rt1uYPfADLLAQDfvl4KbM8vuLugtz5AuxmsFCX2OOSRfKGMDzo+sAwQXc+ULYjg8ltlDYy
	iV1v7/vipq3ddBKA4p5rf1PYNFHazVK2xfzqOH/mndrjXVPLdozIZDH6070IyJgwhr7IEKBdpzV
	pS3hqqzl8Ox2GPW4j5sZBycuFFT9y3ZB/+7XfIJMM6rB9EdR/LrFhQ7lomE6/0S3+t2YB3HAiwy
	vjg96qESQ1rVyAOqv+qqQUXqhY5LeKrJSZsdY+ShBe1KFnjuY39Tn8rk1rBexq/4T4IAYfA4bdC
	CTFnFhv1T6ubrAyumg4mlDEzQJKA+tDSBQmFGdsg==
X-Received: by 2002:a17:902:d583:b0:2b4:689a:e420 with SMTP id d9443c01a7336-2b4689ae791mr137815045ad.8.1776352905586;
        Thu, 16 Apr 2026 08:21:45 -0700 (PDT)
Received: from [192.168.50.90] ([116.87.14.48])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b47826e90csm57355455ad.38.2026.04.16.08.21.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Apr 2026 08:21:44 -0700 (PDT)
Message-ID: <b593ab17-afaf-4128-97eb-0ab9c23dec5c@gmail.com>
Date: Thu, 16 Apr 2026 23:21:41 +0800
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] ext4: derive f_fsid from block device to avoid
 collisions
To: Theodore Tso <tytso@mit.edu>
Cc: Christoph Hellwig <hch@infradead.org>, "Darrick J. Wong"
 <djwong@kernel.org>, linux-ext4@vger.kernel.org,
 linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org,
 Anand Jain <asj@kernel.org>, dsterba@suse.com
References: <cover.1774092915.git.asj@kernel.org>
 <33e8eb64c304a4d42b60f608c26497bf9a2e9e19.1774092915.git.asj@kernel.org>
 <20260323041624.GA11453@mac.lan>
 <d4a9970b-e7ed-4e74-be9d-2d08400f9d79@gmail.com>
 <5bda3d00-df35-4ea1-b313-2fef6e5c5682@gmail.com>
 <adSUiB9L0sFAd04U@infradead.org> <20260407144709.GA81690@macsyma-wired.lan>
 <3c9e478a-42ef-446f-a8cc-1b4ac970d2ef@gmail.com>
 <20260409041035.GC99725@macsyma-wired.lan>
 <22cfbf8d-af9b-462e-b240-67a1de24764f@gmail.com>
 <20260409131238.GC18443@macsyma-wired.lan>
Content-Language: en-US
From: Anand Jain <anajain.sg@gmail.com>
In-Reply-To: <20260409131238.GC18443@macsyma-wired.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/4/26 21:12, Theodore Tso wrote:
> On Thu, Apr 09, 2026 at 05:45:24PM +0800, Anand Jain wrote:
>>
>> Got it. Do you mean that since both filesystems are identical,
>> statfs(A) and statfs(B) can legitimately return the same values?
> 
> Yes.  f_Fsid can legitimately always be zero (which I believe is the
> case for FreeBSD, but I understand that there are some programs, like
> systemd, which subscribe to the heresy, "All the World's Linux", which
> is a variant of the "All the World's a Vax" or "All the World's SunOS"
> at the beginning of my career :-).
> 
>> I'm not entirely sure what the correct expectation for f_fsid
>> should be.
> 
> That's my point, there *is* no correct expectation, and I don't
> believe there can or should be.  What we should be doing instead is
> actively discouraging people from using f_fsid.  I suspect that's one
> of the reasons why FreeBSD may have chosen to just return zero.
> 
> Which is why I don't think we should be testing this in xfstests's
> generic/791, either.  (Unless we get consensus across file system
> developers abnd willing to make it be a documented behavior as of a
> particular kernel version, and we then adjust the test to skip it if
> it's older than that kernel version, so it doesn't break LTS kernel
> tests.  See below....)
> 

Yes, the idea for generic/79[0-5] was really just to make sure
we don't accidentally change s_uuid or f_fsid behavior without
realizing it. It gives us a baseline for current and LTS kernels
if f_fsid/s_uuid is changed. (Some of the submitted test cases
may still need revision).

>> My initial idea was to make f_fsid behavior consistent across
>> major filesystems so that user space benefits from predictable
>> semantics.
> 
> I'm OK with that, so long as it's unconditional across all file system
> types (ideally) or unconditionally across all major file systems (xfs,
> btrfs, ext4, f2fs) as of a particular kernel version (which is
> probably much more realistic), *and* it is documented in the Linux man
> pages as this is the standard behavior starting with 7.1 (or
> whatever), and that the man page further cautions that programs that
> expect to be portable to other OS's (MacOS, FreeBSD, Solaris, etc.)
> should not count on this behavior.
> 

On second thought, we should perhaps consider a more robust ID,
let's call it `f_fsid_v2`. More on `f_fsid_v2` below.

> But given that you originally stumbled across this with Overlayfs,
> because it was originally using s_uuid, and that didn't work well for
> btrfs, why not change overlayfs to just use s_uuid plus kdev_t in its
> xattr, and just fix the problem for overlayfs?  That has the benefit
> that it will work for all file system types in Linux, not just for
> those where we have changed what f_fsid does.

Using `kdev_t` (or any derivation of it) for persistent storage, such
as Overlayfs xattrs, is problematic. Since `kdev_t` is transient and
inconsistent across reboots or device re-discovery, it could lead to
broken associations.


It seems we've reached the functional limits of f_fsid.
If we want to solve this properly for Overlayfs, NFS handles, or a
complex system monitoring..etc, we need a new identifier let's call
it f_fsid_v2, that meets the following requirements:

  System-wide Uniqueness: Must distinguish between cloned filesystems.

  Persistence: Must remain consistent across reboots/HW re-enumeration.

  Non-On-Disk: Must not be stored on-disk.


One possible implementation for f_fsid_v2 could be:

   f_fsid_v2 =  hash(s_uuid, block_device_serial, [subvol_id])

For pseudo block devices (virtio-blk, loop, nbd, brd,..),
the serial could be derived recursively:

   serial_number = hash(backing_file.f_fsid_v2, backing_file.ino)

Note on Hardware Serials:
 Standard storage protocols (T10, NVMe, SAS) mandate unique,
 persistent serials per LUN. While I've seen T10 protocol
 violations during my time authoring Solaris HBA drivers, I
 believe these outliers shouldn't dictate the design.

This approach provides a system-wide unique ID that is persistent
without being stored on-disk. Effectively solving the cloned
filesystem identity crisis.

Thoughts ?

Thanks, Anand


