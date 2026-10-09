Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0084C38838F
	for <linux-btrfs@vger.kernel.org>; Fri,  9 Oct 2026 17:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791567197; cv=pass; b=XGAbyC8Us/tKb6SOpRYIfd79kyZIPnppFn3mhpvCLYW4JLzggd+bzX7TEr9Ov2vzLrSS/Kq2xtd3qVEL0zRDm5g/ZMz69sMs2atKE+RRT7Bn/IipRDtSWxmWGZqmP1CGKoqSCGOcq5QmBmZFMpoolK1nUyLzQGvoUAKKaqT8gUU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791567197; c=relaxed/simple;
	bh=CEKsos3Nrj4zhMS+kSPK10eCZ894/ktNWLSqlQgiVd8=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=cMFtEmbng57JvqhLp0m0RwtiJ8ilQskSVn7KlfnT7tJTynUGDO9RwzUxQW4qopjta51TbKDySn8sc4YY9BAUWK1Tfr6D6EPG+FcxTTqhLDbfprw36eEFxrOvXCiUg1XDxBwX6N1QNAm+3Qk16ItX6KoTaC3WnWj1zPZj3u11Fag=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hl2kvgIp; arc=pass smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hl2kvgIp"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6a642495d81so6965661a12.2
        for <linux-btrfs@vger.kernel.org>; Fri, 09 Oct 2026 10:33:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791567194; cv=none;
        d=google.com; s=arc-20260327;
        b=V9Iktl/JMoF1pkCWY9FeF1LMdEc0sxdS6fftgfhs+0Q8xxiFhJT2ExvhOt5xOfp7xZ
         tYVdFIzJ70IHTEiWYdt5rDg6G+RemGVv3MrXpd56iICGj+BuP4Z7rLAMb0ZIKUphscwu
         8xDoViXvGjW5eJC5voivBQf4n0FVK4/wMkDwd4cNHqO5emDIcLLzJoP2WZnLQckMExqY
         uuKAcSM/a9XzwpDkl3y6uRgOEuHzNHFg/78+YAcGCYtDdRJR0kV7IYIfzJ83NaZm+OBI
         uz4emYYb/ANcQN1oEU9eDiRnsjoI068xiceP9JDVTKwSd+2ZEAqDS7gRTwvoigCf3Eav
         bTeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=GycCquNCIErKH8LdXhnEO5uZpHcepA4syTHfWTAjLwo=;
        fh=IOI3BSFtc4S+mY5yRaEOyEQVEbaexZFmwOG7FNW1hpE=;
        b=BtMNyd9g36Rg4TUuo1YjaOhbVr8bl3YswCKl6Mc3tE4/vYCIV+eS+o1tevdhEXJ9qY
         ExTwLBbSS9bzPkhwASOvl2wnWoCDxofHevccRN4/cZsnO6r2Q5+UIKMKIazARXvEB9/I
         Eb2n5hHiT9iyEdO7E5AFaXo1l/+gaPwqT9PDE/LtIpGU/6ZzW5N50wccuJST04UoCyq3
         9qu71AHcf+7eik3gPYpzTPMmtFAwS3rDXVuhyt0K66cfe+DM7QPpEDtz3sl+2MKxSY+0
         38nTMrtnABAa17OxaSnNXUHS6osy32cEli94xtH8js/lfkDegBjINqzZlEwb9oqBwwvB
         0QZw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791567194; x=1792171994; darn=vger.kernel.org;
        h=content-type:to:subject:message-id:date:from:mime-version:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=GycCquNCIErKH8LdXhnEO5uZpHcepA4syTHfWTAjLwo=;
        b=hl2kvgIpgXhsU5FlzkglUcSPJYYiNFscNQPGsm4ghyXI8VtPzOrzYWCb2tgx8hqxPZ
         ztLUlD7EUfG7ZqUiRwE20yY90zADDD1hiZ83DG0nL6kbtdck5TTZ3gqv9OAVkxc0SUvg
         wyBoLzbHbE84DKzmRnMw4zmb0BdCJq++6Pi3ntxozILxF4tI8JgbknFaTLNR3z4HB6fP
         sYtTfT2UtJbD7I6sSAI3MefD4IIklIvApEVvVpAXBn2jjnUhXWMC5HHb7fkhkBAHv5+y
         PAaQLg0rPMSF0BfWCB+4cQD5EJ5bIFFlPqKRz0vd6b54GLwn7gZZVj7J+a8GobYLb6Sn
         Yteg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791567194; x=1792171994;
        h=content-type:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GycCquNCIErKH8LdXhnEO5uZpHcepA4syTHfWTAjLwo=;
        b=kOob1AV2pZzUF4HYr03eNWQACjNIWfj4IVqgmcuxZ1bCPiZSCuTknSD6C6Uhgoac3R
         rAQVIcEBbY3jDkt4evSRQ0M2jIKzri8epiyeMlk2LzEMVM6u8YZycUI7+VbVX17R/pfg
         9WPgr/UFMxioJgpce2Cs9RPNmBT8inPsOQdi6xsq/QzjPb9HdkEEzyEQ9cLoWhZKcHYG
         FKfOvaGiHjn+ZGsiVX1SWyLOcIxvNnDMHnR1/Aplf+9ewHl68NMuEUJ6ecktwYjWrRk3
         wjS5NCm/Ve8CcDMxtgK6Y9WgLPZ/ddqCIgdd5FsqM/VpbRdCOvS5Nal0y7mFmJvmwFLp
         Zj4A==
X-Gm-Message-State: AFq9FYLWIYJCzLG57NWyXd9eBDJggLPHzOCr4leMzSLHR5w/Kt2FZt8w
	9ZjGt4cLHhkivA0HojCWl9ZjYI7dazFihRTSvCVSlVs4caKJ0eAtyhDMUfDSR29rmxVkSsl9KKb
	aMOSQn5Qvr1/Vky6XvyUC3IGH0cbnveLpUbN3
X-Gm-Gg: AYBFou1JCmtdY06XnZJKQMCrNTyJCe+GQgTwriHg+AHl8L8UPy/pCkDlJ7pBqulA2NL
	M916UUeqtg1Oar5JdKm4M2xNWfcg4XR0rFDvLjOdTPuZ9ekdiL70qBPHk//75mf/qMHZhSWnkoQ
	4EFjU6hwi79YoWOnWbsynyY/neK59bXkrQdEyoSn1a8I9OHcsj2aZfn9lZ9TzbPahN6o8M2N7EI
	WG9DFYM6UaJ3RgT+CeUybLXs4rRbHKPPDA2i9iC6bGeAmvaamUGKNX5dqVCeCiRDMhxvwVV5zWn
	RqojBlVl7pquirYkrQco5D8VNQMA6JA1sYmCHyaGTn9SY/40+WwjSo7o399aykk8HNDoEdzsRQa
	dAOPalm3eP/bEGjlyV8SLxvd9X0+gYWBtEGNCUuiv
X-Received: by 2002:a17:907:2d12:b0:c2d:b9b4:f4d1 with SMTP id
 a640c23a62f3a-c31a9a29d5bmr253961366b.6.1791567194128; Fri, 09 Oct 2026
 10:33:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: =?UTF-8?B?Um9nZXIgQWxhc8Og?= <vonbloom@gmail.com>
Date: Fri, 9 Oct 2026 19:33:01 +0200
X-Gm-Features: AclHuK8I26_gHo-Jf0qOWJC_wgIMpY6_Eldz-XfGaSX-a_zyg8_yzTJ4IKYL778
Message-ID: <CAELqY9=eoM-v816v2otCNitOgAFnrWZ776F3RECwPOwKveA=zw@mail.gmail.com>
Subject: fsverity@lists.linux.dev, regressions@lists.linux.dev
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi,

Since 7.2, reading an fs-verity file on btrfs mounted with
compress=zstd:1 logs "FILE CORRUPTED" for compressed extents read
through readahead, although every read succeeds:

  fs-verity (vda3, inode 58996): FILE CORRUPTED! pos=8912896,
  level=-1, want_hash=sha512:...

(one line in dmesg, wrapped here). The positions are mostly multiples
of 128 KiB. read() returns no error and the data is correct: the
synchronous re-read passes verification. We hit it with composefs
(bootc) objects on the root filesystem of a laptop, and reproduced it
on a second machine and in a VM.

Reproducer (root, any btrfs mounted with compress=zstd:1):

  cd /mnt/btrfs-zstd
  find /usr/lib -maxdepth 1 -name '*.so*' -size +500k -print0 |
    xargs -0 cat | head -c 60M > f
  sync
  fsverity enable --hash-alg=sha512 f
  echo 3 > /proc/sys/vm/drop_caches
  cat f > /dev/null
  dmesg | grep -c 'FILE CORRUPTED'     # 10 here

Same data with chattr +m before writing (uncompressed): no messages.
Reading with POSIX_FADV_RANDOM: no messages.

Tested on Arch Linux's kernels (no out-of-tree patches) in a KVM
guest, virtio disk:

- bad: 7.2.2-arch1, 7.2.7-arch1, 7.2.9-arch1
- good: 7.1.11-arch1, 7.0.14-arch1, 6.18.55-lts

Also on bare metal (two NVMe laptops, Intel and AMD) with
7.2.9-cachyos. A similar symptom in 6.16.8 was fixed by "btrfs: fix
incorrect readahead expansion length" (Oct 2025).

#regzbot introduced: v7.1..v7.2.2

I can test patches.

Roger
