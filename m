Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792703456;
	b=KBi4xXWQ/KOPUSRyRL75zIkbXgkcUSu0XBvUvvQWV0voj4p6B90KTYSn27FNvuflZmWK
	 TcT1KR8F1lRmEXCFz9O6pSuekJ0RV3G89c25mK6VtVDzeEPIhUy90mwwPFhzWnP/cVVef
	 L9/UvljI/7DnXGULa4XdmM5Pe6XxnubZIIq+GpRhQ+oeecGODM220mJpYxJPVpn+pPelu
	 l8ml6C8goDg8n2H9mzElqpfeOOOXaNSfk6+YVYSKUWFZl94u3APWukO7W9RyKGC/givOg
	 5Q1qy3U7iywi/rk6PSoM5HO8nYhfUKQBgGjNXDvawhQTAcegpvr+LxbGMVLglNNgN2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792703456;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=WCOooTmfNv8SyWhWwePPeUfANqT5hEe6MUgW5t15uFA=;
	b=G/DWyPD4Jrzl7uPkHSujmgW5aAEC9kVLPJaCbAIGUnds1lQEEYagcJ1mEXa0eMTp4gmZ
	 8TyU5Ss81pzFXkd5DJYC1Yb+TwDJRM1hlRdO7oGZOhjnMbiO1If7TWtyCXjejQ72nuurZ
	 Ezhla5amTZxrN5jNYD/0IVVmyOL0ZEV0eJ8r1sl6iotkCIXYk6OhZZPAlCt1hG1S2cum0
	 pczxSlNiQWxetwwP0JchLDpnirq9aOtNcOkifVbVnQ4qFQ6eLGuX4kpdJBZrTpV00n2g3
	 emdKddOwV9c+NA8Lzrucr5cNVGzZ9XI5kDwMbU2y3bdPsA7oaUJUl4mZvwnqUihgwlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=ZU3SE8BF;
	arc=none smtp.remote-ip=209.85.218.47
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 946E2606A31D
	for <linux-btrfs@vger.kernel.org>; Thu, 22 Oct 2026 21:10:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 946E2606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=ZU3SE8BF
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c4203bbb1e9so37403166b.3
        for <linux-btrfs@vger.kernel.org>; Thu, 22 Oct 2026 14:10:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1792703454; x=1793308254; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WCOooTmfNv8SyWhWwePPeUfANqT5hEe6MUgW5t15uFA=;
        b=ZU3SE8BFhiQLWDBsOuDDGid7SRcel6Ku18lncRMwfV28E3hSTs04flm9jJNZwST/gX
         p08XOTfrRfBA2s4Mjxeo3877lj+93Ld9pwzlzzudi57ecXkHsiJbxO+61FSSL0Uts0Yd
         uwFZzRE2CK2udVeGuCZrM05K7ZT3Qn4iroD/GPAEDMeWYPA8LTReJQaO8GtvpUyshS4Y
         fvGBGt/Aj3x250992xIFOxVz7H5oWRJ1ihXSoach7IuZL/Ym/9XV7uvN23o2YtiJcZYO
         ybBeNcOopLANjUwom0nLsPENohvNTwBJWGMBRDzucpFd/eMpbylXRUQqmG0WWwFNeiV5
         4qrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792703454; x=1793308254;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WCOooTmfNv8SyWhWwePPeUfANqT5hEe6MUgW5t15uFA=;
        b=KmqfMYs8BKAOmoqEAcAN+QAKYgQemZGYID0Ebi5YRWWRRm8XJtOWFOnVZjvWadJ7Y7
         igKfouClJCLigirgwj/u9CGGlV312S36KVNTCPDZEtayOSZ2eM6TARtFr59pTvzC99rj
         fIBR2BrAbIZsYMflXXXM2TL4eOdxfy5TM/YRmzBOWL5umJqIsb+1oHiIPt++oHSElHMl
         Ai56x1nPkrGxBorpREXimo0TNk4U00ajhVNxUBUpfYHltskub1RV2b9gkc+CNlyYud23
         ksYc6vR7/TaV4T7jJjAjV8/hoKlcHEsNtGGg5TSCzaXdNuPtvf0mh+tFO/5bhvJMvXS4
         MVpQ==
X-Forwarded-Encrypted: i=1; AKwUvBxYA9/M9vi4wEIKFQ/Cij3qMA+gII653ZtmK2LQG0h6oCF7YHQ5Wt5caQ+QSR+SreW2Yas6QIm1Q0PYBA==@vger.kernel.org
X-Gm-Message-State: AFq9FYLsXdWjNn/uwoLQAF5v5e0Xi0YqTl5IPhVnf3CqNvYg5BJSt2bl
	+o18lz8YwAIPzpd27B/aaX31Gpi6BD6Qpu3q6Yx7VRAAZTkd0Iu7j+x25hYAey4EVAI=
X-Gm-Gg: AYBFou04pmiQsjm54+vQ/38JB22WoyLhJxV8KEscNYLfTFKzc7FOXN9SzJ4Yc3SPKAm
	dgyY52HvSUvhTzSeW5X9AwZLa3hOk1mkD+km6qbGhRBhcVvoJI3xQjItTyrfQ4Q/wAizX+pCNXP
	kiUQEG9Sw+177qQF+SNyJ7FWUHh/dHN4yveVd+W7iKhe/lOpQjdC5EzSSN2gCdZLvaFzUpJbXPI
	z0xh+nFPResTqKzt1Mmr5OcjndPSKMZyOC6H6IYihgvI6YmSxkTcqfDq6MBgj5ct1J+ojSxefu1
	JmLPqMUUSPkZ+tcXujxzBxn6nNZBVHe/umbr1Lj544yw55YLnThc1F3E2RaWrapqkb5RoQ34xmw
	BZx/OYRg1qpNcLJ4w9H6Khf4BHMK4cScohS4rUDgXOOEp733rrvsrxLM7M4H7H2IDNGu3lI0a4x
	1UNeG2WoXUes8oE2RYZKmJYgF9JBpRElIUIWr41DZZvvr3YKCCzlKHpcHmYxjJP9ZSKXSU63hNZ
	MGuFZGMNglJF9D2Ng9FIG1f6WCieuykUZvG8AOV7b1J3r+e
X-Received: by 2002:a17:907:7b85:b0:c2b:898e:24fd with SMTP id a640c23a62f3a-c46a906d2fbmr49461566b.33.1792703453876;
        Thu, 22 Oct 2026 14:10:53 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a2c92fa74dsm81160b3a.51.2026.10.22.14.10.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Oct 2026 14:10:51 -0700 (PDT)
Message-ID: <0a75e68e-cc65-4567-95ad-e731ef78e4d6@suse.com>
Date: Fri, 23 Oct 2026 07:40:46 +1030
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] btrfs: test that fsynced data on a RAID stripe tree
 survives a power failure
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 linux-btrfs@vger.kernel.org
Cc: Zorro Lang <zlang@redhat.com>, fstests@vger.kernel.org,
 Filipe Manana <fdmanana@suse.com>
References: <20261022090754.2584747-1-johannes.thumshirn@wdc.com>
Content-Language: en-US
From: Qu Wenruo <wqu@suse.com>
In-Reply-To: <20261022090754.2584747-1-johannes.thumshirn@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/10/22 19:37, Johannes Thumshirn 写道:
> A data extent in a block-group that uses the RAID stripe tree has its logical
> to physical mapping stored in that tree, which only becomes durable when the
> stripe tree is written out at transaction commit. The log tree cannot carry
> that mapping, so an fsync served by the log logs a file-extent item whose
> logical range could not be resolved afterwards. Log replay restored the file
> with the correct size, but reading it failed with EIO.
> 
> Extents reach the log both from log_one_extent() and from copy_items(), so
> cover a fast fsync and a full fsync.
> 
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
> Changes to v2:
> - Also test full fsync
> 
> 
>   tests/btrfs/363     | 67 +++++++++++++++++++++++++++++++++++++++++++++
>   tests/btrfs/363.out | 15 ++++++++++
>   2 files changed, 82 insertions(+)
>   create mode 100755 tests/btrfs/363
>   create mode 100644 tests/btrfs/363.out
> 
> diff --git a/tests/btrfs/363 b/tests/btrfs/363
> new file mode 100755
> index 00000000..834f2673
> --- /dev/null
> +++ b/tests/btrfs/363
> @@ -0,0 +1,67 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2026 Western Digital Corporation.  All Rights Reserved.
> +#
> +# FS QA Test 363
> +#
> +# Test that data fsynced on a RAID stripe tree file system is still readable
> +# after a power failure, both for a fast fsync and for a full fsync.
> +#
> +. ./common/preamble
> +_begin_fstest auto quick log volume raid-stripe-tree
> +
> +_fixed_by_kernel_commit XXXXXXXXXXXX \
> +	"btrfs: force a transaction commit when fsyncing stripe-tree extents"
> +
> +_cleanup()
> +{
> +	_cleanup_flakey
> +	rm -fr $tmp
> +}
> +
> +. ./common/filter
> +. ./common/dmflakey
> +
> +_require_btrfs_mkfs_feature "raid-stripe-tree"
> +_require_btrfs_fs_feature "raid_stripe_tree"
> +_require_scratch
> +_require_dm_target flakey
> +
> +# DUP keeps its mapping in the stripe tree, so a single device is enough and
> +# dm-flakey can be layered on top of it.
> +_scratch_mkfs -d dup -m dup -O raid-stripe-tree >> $seqres.full 2>&1 || \
> +	_fail "mkfs failed"
> +
> +_init_flakey
> +_scratch_mount
> +
> +# The first fsync of an inode is always a full fsync. Do one here and then
> +# commit the transaction, so that the second fsync of this file below is a
> +# fast fsync.
> +$XFS_IO_PROG -f -c "pwrite -S 0xaa 0 128K" -c fsync $SCRATCH_MNT/fast | \
> +	_filter_xfs_io
> +_scratch_sync
> +
> +# Fast fsync: only the extents changed since the last fsync are logged.
> +$XFS_IO_PROG -c "pwrite -S 0xbb 0 128K" -c fsync $SCRATCH_MNT/fast | \
> +	_filter_xfs_io
> +
> +# Full fsync: this is the first fsync of this inode, so all of its items are
> +# logged.
> +$XFS_IO_PROG -f -c "pwrite -S 0xcc 0 128K" -c fsync $SCRATCH_MNT/full | \
> +	_filter_xfs_io
> +
> +# Simulate a power failure. The log is replayed on the next mount and both
> +# files must still have the data they were fsynced with.
> +_flakey_drop_and_remount
> +
> +echo "fast fsync:"
> +_hexdump $SCRATCH_MNT/fast
> +echo "full fsync:"
> +_hexdump $SCRATCH_MNT/full
> +
> +_scratch_unmount
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/btrfs/363.out b/tests/btrfs/363.out
> new file mode 100644
> index 00000000..fcf6e0a7
> --- /dev/null
> +++ b/tests/btrfs/363.out
> @@ -0,0 +1,15 @@
> +QA output created by 363
> +wrote 131072/131072 bytes at offset 0
> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> +wrote 131072/131072 bytes at offset 0
> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> +wrote 131072/131072 bytes at offset 0
> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> +fast fsync:
> +000000 bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb  >................<
> +*
> +020000
> +full fsync:
> +000000 cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc  >................<
> +*
> +020000

