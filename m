Return-Path: <SRS0=YhH7=Q7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04B07C43381
	for <linux-btrfs@archiver.kernel.org>; Sun, 24 Feb 2019 17:40:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8421020661
	for <linux-btrfs@archiver.kernel.org>; Sun, 24 Feb 2019 17:40:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=captnemo.in header.i=@captnemo.in header.b="AREAC795"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728044AbfBXRkN (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 24 Feb 2019 12:40:13 -0500
Received: from out.migadu.com ([91.121.223.63]:52100 "EHLO out.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726489AbfBXRkN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 24 Feb 2019 12:40:13 -0500
X-Greylist: delayed 452 seconds by postgrey-1.27 at vger.kernel.org; Sun, 24 Feb 2019 12:40:11 EST
Received: (Migadu outbound); Sun, 24 Feb 2019 17:32:38 +0000
Authentication-Results: out.migadu.com; auth=pass (plain)
Received: from me.captnemo.in (abts-north-dynamic-159.129.177.122.airtelbroadband.in [122.177.129.159])
        by out.migadu.com (Haraka/2.8.16) with ESMTPSA id 530CCF25-D4F5-4C63-86DD-BEE56C0B7664.1
        envelope-from <me@captnemo.in> (authenticated bits=0)
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 verify=FAIL);
        Sun, 24 Feb 2019 17:32:37 +0000
To:     linux-btrfs@vger.kernel.org
From:   Nemo <me@captnemo.in>
Subject: RAID1 device deletion feedback
Openpgp: preference=signencrypt
Autocrypt: addr=me@captnemo.in; prefer-encrypt=mutual; keydata=
 mQENBFpD4wcBCADit38XMMXjMmVa6r9s3zEn8XSZXy35Nf+IlUZOYm5OhvQowoWxhfXI5Gtt
 XIJjZ6NbSaqz5Wji843CJroXVQu9bm8v62w8d3DexkeL+ArU/aBrqACQ+JwJT/L2y/mZxY7A
 oQxqdEUq4rWibkW8bihurP23s7G8R/7oX+zZs1pbBTBMvr3DMpLP55L1EYJzaMAqpz2fMEe9
 ty6pmaRXiG1bOcLES6yIjKi5NJtmqqgmmG/PjlNfH8aLqYSBYO+FM1st604yNg2w8VLG8Wy4
 VER7m121BbY3pPWWY8+ck1+Q02DQk1hVCkBSFySqF2uvGDHTLLy24MiwoN94TuVKJV0jABEB
 AAG0G0FiaGF5IFJhbmEgPG1lQGNhcHRuZW1vLmluPokBVwQTAQgAQQIbAwUJA8JnAAULCQgH
 AgYVCgkICwIEFgIDAQIeAQIXgBYhBEaPkQKri/jJWcL5pPlOp0pOqetSBQJbCt/jAhkBAAoJ
 EPlOp0pOqetSPIUH/3ycEwkQOfqmca7xXZnxpMPQHxRGB5faBH+mLjRr336VGRUpVDY78hIc
 QY2QmKxliCJX0p9X/Q0ukL1hqVtgwAjlREwXod2DP3Bz9SxgN1ci43XTuLvqsk/Cros/Yi3j
 oR5ADvvlF1V3ta55AjL6WsUpEpl0GEkmNLXG2ExNRXxT67O83/UU83KZUeZ2fLNiB1BUpmVl
 c9VsWHXeb6wcTGVDCh8+hGjhd5uitk/hgwi+TQzDE80dGpdKDXBsag66j5kuk34mSXuZU52R
 1qZ7fho/2pjHu0NfQP8BbfdNZVLv0NXuyEYP60nPGIOw35FfCEg+fVnKUfIHUpj/1WWIgha5
 AQ0EWkPjBwEIALl/Ty0Rp+DFdIvKUZDobRHMUBmQtTRhDeibKUbWXzTa3cbMY2CM734Rk+Wf
 5bZU94bHbiQXtEmQSCtYIBf7xNyfnoaPwzkQv8m2p2xQJp0iDmhHro3OjAbAGZa7e6URlGTH
 M5cIoHgXOcGzTWjKqoTY65hWoT6tHhsiqWC8Szo+afqUXXL8R9SIPeWnjknguDhm/hQ6nidk
 6CpcA9+tVfSWYLoYnePTvsr5Lmz4i24Y+xm7fq/g0I0qkZ5QtKGQckfuAWaqcRUHcqJ6OSOA
 RxsVIcKRSCGJvM2LcNKqpX5NQtEPw8+mc4GMlg9eS8/UzwrKR9u94iVIKlLNwyhrcOcAEQEA
 AYkBPAQYAQgAJhYhBEaPkQKri/jJWcL5pPlOp0pOqetSBQJaQ+MHAhsMBQkDwmcAAAoJEPlO
 p0pOqetSOD4H/3HY+k+0nrW1DwmJBikA0avwLFLrlvPkf7tafkBUUIZ5kw8xbmzd8wEUtq+Q
 h9kxnQxqaBN9wdHN0pJFF5gdn67i4HB3OvdkkDa8OZUCUYpWOgsU65PVXYglhGCh2axiEySQ
 UrFamatGA4WbQPv5uL5ur9hxR0Pqypwa/HtHAUonszy77WB1eaEprrrjDnyNfqWu8vyTlE3N
 rlErmBomtHyBBS9OpCzzVZnylsy8GpvlkTRI//xMzfA896q+AyMYYGGJLgctY97/T/0WZSFa
 9WNFrOQxywKmZszUzivzzKMt9tFRUdGdltYClS8grIBpP4ZPZY95UZA/AI2gOoF4PbM=
Message-ID: <d1eac64c-056b-a95b-7890-875d313a7ab4@captnemo.in>
Date:   Sun, 24 Feb 2019 23:02:35 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
DKIM-Signature: v=1;a=rsa-sha256;bh=kaKZlRmALXBkWfzW/SA41yGtvInBR+bikgZx7loeNgM=;c=relaxed/simple;d=captnemo.in;h=from:subject:date:to;s=default;b=AREAC795DGCZPwYazmNtFAPPsMb84+J+PFC5WI2oabUybUP3pA0T2ni+kjJ5RzNtMglPuFNX8Mn88BdnE4h+ZmQg/aJqwRASB+RbSZa3U6W58ziy13wJrwxALCzGYBAB6iT3h70Hx5jrLkpf4ly8WezBkacfRCY7CXh2IcV2Q+w=
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,

I had a RAID1 disk failure recently, and a limitation in number of SATA
connectors meant I could not do a live replace. I'm still in the
progress of resolving the issue, but posting some feedback here on the
issues I faced and what could have helped.

**What all I did**

- remove the dying disk and mount in degraded mode. This didn't work,
but _didn't provide me a failure reason_
- swap the dead disk post boot with the new one. Tried a btrfs device
add, but it failed as well because of too many failing reads from the
dead disk (which wasn't even attached).
- Started a btrfs device delete, which finally pointed me to the root
cause:

`ERROR: error removing device '/dev/sdb1': No space left on device`

In short:

1. My 2.7TBx3 setup was storing 2.9TB of data
2. Removing any one the disks was not possible without losing some data

However, getting to this error message took me hours of effort, despite
having read the btrfs wiki.

**Feedback**

1. The `btrfs device delete` command should have failed immediately
instead of making me wait for ages.
2. A delete command should stop writes to a disk, unless avoidable. This
would have left some data on the disk, and a subsequent delete could
have cleaned it up much faster. It failed in the worst manner possible,
because all deletion progress reversed once it failed: it balanced back
to complete usage, causing more strain on a dying disk.
3. A degraded mount failure should provide some error message.

*Status*: I cleared up some disk space, and ran another delete which is
still ongoing. I don't have physical access to the system for a few more
days, so adding the new disk will take me some time.

---

## Debug Details


```
uname -a
Linux tatooine.captnemo.in 4.20.10-arch1-1-ARCH #1 SMP PREEMPT Fri Feb
15 17:49:06 UTC 2019 x86_64 GNU/Linux

btrfs --version
btrfs-progs v4.20.1
```

A few more details are on a reddit post[0] I made to help debug the
issue and a gist[1] has disk usage and filesystem details.

[0]:
https://www.reddit.com/r/archlinux/comments/asrlam/btrfscleaner_at_100_cpu_usage_on_raid1_setup/egwc047/
[1]: https://paste.ubuntu.com/p/GDNKNBqqFy/
