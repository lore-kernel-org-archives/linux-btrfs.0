Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.82.175
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793090174;
	b=NiSjEJ0WoHoH0Z1bwUpqac7p9tONHh/7kCnCMKSt9V5TVe+UaG5W+0M2MDhu8XZrOf/t
	 4/2ju5cn9jFg0ffzB6Cr0+Dyiu6LBu97XvaIPiMXg8upH8DjsJhR3VXn+nteUnLTtV0A1
	 Yd952rzfrzNB28Etf4l0b2a9webd/nTfdaTXPGbb5Se2vfMbjpggAP0AKBeBDxFGxHEG9
	 McnX8ADgYogZVSEf0THL6Izg5zoKKfU42hohbr9uDkg7tIpLcDHyUqGFG9ePA3aAuWn7h
	 3EqoXYxevdWZMb9657CY+cJpqkNDD57kxuNyrPsdO7Sx+zEORBny88EtHIX/kBBHOqQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793090174;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:From:Date:X-Gm-Features:Message-ID:Subject:To:
	 Content-Type;
	bh=533OwAPWq4vOQ8kxsIt4qtc5nCMy/Yh65N5bfM5agWA=;
	b=2zeIawn1PvMqMC3p796PhWpqZ13s38G0GFUPfUCv5QaczAEoOEyNYQUTGUXyx55N5PmU
	 VhiV3aysDwafdVeQ9YX6/4a42B4rFr0XJ1p9XsFDCTtFbtNtNzdF5nulKMGa5b0dyRKp+
	 wY8ORSnT1bGjYTvhZLacO6Y/t1a9lTRgw5EFJhcPDHe51Qme7oE2BCMtGNlEtPJWNCHyb
	 UBV29mtD/qRMklUTfu8OHBFhu8OI/183dbiTDcNxkiJxffBPGiLDPSPKmL8Geyw2s72s9
	 +vjSPkCEb4Hb6UUFOUrtfrA8w2Ck5HBDYh/H3rHUiqJ7Gq2VyfZGnM2/s31nuLyptzw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=aa0vsv5I;
	arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.82.175
Received: from mail-dy1-f175.google.com (mail-dy1-f175.google.com [74.125.82.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB85D606A335
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2026 08:36:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CB85D606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=aa0vsv5I
Received: by mail-dy1-f175.google.com with SMTP id 5a478bee46e88-3514b90bb89so8766620eec.1
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2026 01:36:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793090173; cv=none;
        d=google.com; s=arc-20260327;
        b=VXOxJN+eAsD5PpRTGwq1YlVqB5S679bJyovvir/CxGZzXz2Qc1Dyl9R5wQDqiimr14
         62QdenFmQY9fLKcBRDqMbWzCDMdr2u1jnFXyP9pNW+BsBq3Aa6+helFG779XPGOW4TG5
         L5MpI04AMURc21zBuud/z4O2Nt5Xju3lhwMLaIna87ngjOpV1b+NE/iCY7NnEekT8D4N
         xCb5c1vLgAlM1LoGIguKOTTVPVk4EVRpXKOpzm4BctNGHM59rJNaJ87q6AicVCwr7ma7
         tfrcNZNDJ1aFlgJOEfbixp/Ry1t/9VPxKDhDZHIhTsWL/PAsfDBCzrMnZzlJm1dehTF7
         Q1Bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=533OwAPWq4vOQ8kxsIt4qtc5nCMy/Yh65N5bfM5agWA=;
        fh=IVbHDkNMahLBNl1Si+GuxSm6N+J+TeYWQ1v4HqkLlHY=;
        b=lVTyFjUY8xb0oqEzbgU8JT/CKCNQcXMDcbuZG0kjOLLal7avHWmAuHiBUt8IKJyTOH
         Z/pnOZB8bfm35bUie83cCb2Zukg9ktuD9jhnvUBTbyObptHI1FwXXDgeiukc7qkt2GOB
         B1bobCXMAUzcHBzJjh34McY4QiIaXjcaeYozHDGehFPf/slnGSZEOuPOfCskhexpYLOS
         Oe5XH1SkKB7cTH0WyRSa2KQL2IoihAi8ojtQRU0TUC4SCyJalcE//4y+o8fd1GtIMLEG
         N2hiGvSGKZx1EO68l2Qij/2rHOaNMZAgunl80O5YQ7k/eagnFmMdOQSpwHjme+4ORxd1
         Ss6g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793090173; x=1793694973; darn=vger.kernel.org;
        h=content-type:to:subject:message-id:date:from:mime-version:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=533OwAPWq4vOQ8kxsIt4qtc5nCMy/Yh65N5bfM5agWA=;
        b=aa0vsv5Io/41U+ggVEM6mQUORlawKEdfZph+jyb++6f3ALT4dKeK9+jtwFYylo06+X
         KTMEVjqhut8tSbeYQ06lAApNxcGUYt2oeHDuEzngSJUmbe98qL1ynJGUckPvL02WQC71
         UHMj2Zwu4fT0b76KsGiKlLV/IMNBlteGg4P9oHSDHqUdc/KXKmVIgqES8Jr7Az8aVAbw
         ZdKUIuU5niw+ypLOSEHjLjkXLF/xeDNOQrkCwcxT1eUv4MJsECN8sXbzBIp5xBHyljco
         /ze3oDzJyffnkxS9YhrDTdYhrTn8nJyTAbjd3j7EnUQofw4u67K8MOaznqDZCXM/2srH
         R4eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793090173; x=1793694973;
        h=content-type:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=533OwAPWq4vOQ8kxsIt4qtc5nCMy/Yh65N5bfM5agWA=;
        b=WjLnsFJrTC4PHurYFw0JF+PYypXdSyLE2EndUBX6cjycqLVj3Sc7u+WayEIgqmgoez
         s5mid8P1yQfC11yzY3JIzgYioofz5uLxAGVmgqbtQY9dI03afIzWE/wmHKWhH+ZYY8KQ
         2gVV7P3zSw2kZUkVLKvJ1B2D1f3ZwyjHZ0cqa/nqnvc0xbe2MTVDwNZ+dtMZqv1n7y3+
         XTVBuWh1PwicupLUi6tBISz2trWZe6NJqM9LrsGJHdQeGylwppSv3TmIoq7fl/+xuXts
         FZGcdoPs1NTtQrTVqBHyY1BUuAHmOGPPtpRdOihZV6i71BhNiqnLWHO1XmdJbv3hg1+G
         8smA==
X-Forwarded-Encrypted: i=1; AKwUvBxdX/HfoSFgycgH48qa7E4PS3/w+Y3I09g/BnpGcF9EsRGTICLp7PSL+CdfVjGXz6hsuCkFE4fyy6MG4g==@vger.kernel.org
X-Gm-Message-State: AFq9FYJUT7xRa7S458Yj5z8h0pKuIVTQAFTGxV7cwsaUnwQs5KL6E3sD
	t3q99iSLOPJDs+jKe5y66hf8nU+qlw6AubqGL6nUMpNDXsgPkktzRtHRHGcaUUuERFPQoTgidQR
	a1YNN2Mp9gjhgTe4olHquhhSVafoX2qQ=
X-Gm-Gg: AYBFou1PVZPJK2p4yYDMd3fS0692ZGF8y7Y54yPGtSjmtthXrswy5/I0qOPA0b0V2gG
	XZHSca2GSC0X9x254husppRMsdg8k2FuPJp/kT1KOvNCDQg1CsKAMB3ZVNj18PQTEX+iq4HYGUh
	mplsvCBgMXEUlB7eDptBgRWRWjEAbz4EYMxqrkIK3Kl5JM3ECFTQFJTGRolzyJVlO8Y1+VLv6KN
	lj4jwcy9a9fRiCiGIYOttE3C+G+e4lBqzlg0Q/HTJGLhtLuqkHBRVZtiCPze7poNtbJGGBkWvu+
	oe1q9NSX7S0slQZOttYw2EAdMBFdynWbcbsT33LtmskHl+oNN0bMEmDK0bE+AJkPgRrAIHjoynE
	60+75mxc36G2Xs5NWFkljD/Y+53Wq0gLrkThZcuOZKkgvTrEWSmw9I9Dclf4LLnIgVgRZ2IIKWJ
	DDwlLSyo7BZpy+FtNh819xBn2etR6LT9cpyJHPMb8txWaVyg==
X-Received: by 2002:a05:7300:fc0f:b0:33c:16f1:2e11 with SMTP id
 5a478bee46e88-369e845b068mr14555898eec.7.1793090172731; Tue, 27 Oct 2026
 01:36:12 -0700 (PDT)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
From: =?UTF-8?B?0JzQsNGA0Log0JrQvtGA0LXQvdCx0LXRgNCz?= <socketpair@gmail.com>
Date: Tue, 27 Oct 2026 13:36:01 +0500
X-Gm-Features: AclHuK8LYf_8PYVj_mbhVWX4NzizhrOEbQrV-IlYGk176whN1q7kTKLieg1M1X8
Message-ID: <CAEmTpZGu5x9PS7vFwgc_dFH80rL3cFD4-geuuL_w8i=vFDo8AA@mail.gmail.com>
Subject: [RFC] btrfs: zoned: reset stale zones in unallocated device space
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi,

I'd like to propose a feature for zoned btrfs. I'm not planning to
implement it myself, but I'd like to get feedback and, if the idea is
considered reasonable, have it tracked as a TODO / project idea.

Background
----------
I maintain a host-managed zoned block device implemented with ublk,
where each zone is backed by S3 objects. Storage cost is proportional
to the amount of data actually held in zones, so zones that contain
data but are not referenced by the filesystem are a real cost, not
just lost capacity.

Problem
-------
With a long commit interval (e.g. commit=300) and heavy buffered
writes, btrfs may allocate new block groups and write a large amount
of data into their zones before the transaction commits. If the
filesystem then goes down uncleanly before the commit, this is fine
from a consistency point of view: nobody called fsync(), and after
the next mount the filesystem is consistent at the last committed
transaction.

For a virtual device like mine, "goes down uncleanly" is more likely
the ublk server crashing or losing connectivity to S3 than an actual
power loss, but the effect on btrfs is the same: the running
transaction never commits.

The device extents of those new block groups were never persisted, so
after the next mount the corresponding zones belong to unallocated
device space from btrfs' point of view, while on the device they are
still non-empty (write pointer > zone start) and hold data.

As far as I can tell, btrfs currently handles this lazily: such zones
are reset only when the allocator picks that range for a new chunk
(btrfs_ensure_empty_zones()). Until then they hold stale data
indefinitely. On SMR HDDs this does not matter much, but on ZNS SSDs
(where a reset helps the device's internal GC) and especially on
virtual/cloud-backed zoned devices it does.

(Stale data past the committed alloc_offset inside *existing* block
groups is accounted as zone_unusable and can only be reclaimed via
relocation; this proposal does not try to address that case.)

Current workaround
------------------
The only safe way I see today is offline: unmount, walk the dev tree
to collect allocated dev extents, and issue BLKRESETZONE for every
non-empty sequential zone not covered by a dev extent. Doing this on
a mounted filesystem from userspace is unsafe, because it races with
chunk allocation (a dev extent may be allocated in the running
transaction but not yet visible in the committed dev tree).

Proposal
--------
Let the kernel do it, since it can serialize against chunk allocation
(chunk_mutex / device->alloc_state). The operation itself: reset
every sequential zone that is fully contained in unallocated device
space and whose write pointer is not at the zone start.

Possible interfaces, in order of my preference:

 1. Automatic background cleanup, e.g. once after mount (after the
    dev extents are loaded) and/or as part of the existing
    reclaim/discard workers, possibly behind a mount option or sysfs
    knob. This requires no administrator action and covers the
    problem completely.

 2. FITRIM: on zoned filesystems, apply the reset to unallocated
    device space as part of fstrim. Many distributions already run
    fstrim periodically (fstrim.timer), so this would also work
    without extra configuration in most setups, and it fits the
    "release unused space to the device" semantics.

 3. A dedicated trigger: a new ioctl (exposed as a btrfs-progs
    subcommand) or a sysfs knob under /sys/fs/btrfs/<UUID>/ that
    starts the cleanup on demand. Least convenient, but still much
    better than the current offline-only workaround.

Risk
----
With corrupted metadata (a dev extent missing from the dev tree),
this could reset a zone that actually holds live data. But the
allocator already makes exactly the same assumption today when it
resets non-empty zones before reusing them, so this does not add a
new class of risk; it only performs the reset earlier. If automatic
cleanup is considered too aggressive, options 2 and 3 are explicit
and opt-in.

Questions
---------
 - Does this sound like something you would accept upstream?
 - Which interface would you prefer?
 - Am I missing a reason why the reset is intentionally deferred to
   allocation time?

If the idea is acceptable, I'd appreciate it being added to the btrfs
TODO list so that someone interested could pick it up.

Thanks,
Korenberg Mark
