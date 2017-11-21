Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f176.google.com ([74.125.82.176]:34261 "EHLO
        mail-ot0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752429AbdKUEq1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Nov 2017 23:46:27 -0500
Received: by mail-ot0-f176.google.com with SMTP id o23so9528939otd.1
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Nov 2017 20:46:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56401bb3-39fb-66d9-f77b-30e164bd8973@gmx.com>
References: <CAJCQCtRpWuPLsmGLmNcon45YzfewRFPHxjhCJY=mVZ_Od7jxxQ@mail.gmail.com>
 <d784d9a6-bc0e-e4c3-6633-043081ea800b@gmx.com> <CAJCQCtSZmRmeFUGPSiRLV4TCOjbD6uTqpoEqKD24Li8w1iO7qQ@mail.gmail.com>
 <0f6c7514-1cf2-1d88-1307-c43f7642b525@gmx.com> <CAJCQCtSH-w4Pt9kmGhuYZUX_FdktFEpV4WyKnxw5GaDKfVmdng@mail.gmail.com>
 <d8973b92-b320-5088-aae6-2b3835f1b2ca@gmx.com> <CAJCQCtSjBWMauccwremxQ+eCTTBXsz=VEXFy=ckABpKtC-9NTw@mail.gmail.com>
 <af39cb86-693c-2f3b-7831-60968d3b5c3d@gmx.com> <CAJCQCtS6tXcKRuwZiAfB8eUkENz6secVcvxYS=syCFp_VH_+Vw@mail.gmail.com>
 <56401bb3-39fb-66d9-f77b-30e164bd8973@gmx.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 20 Nov 2017 21:46:25 -0700
Message-ID: <CAJCQCtQjfAcqrJB_fg4_tB2uSpQk=Go4uzfJ1fzxbJN=Hqf3-g@mail.gmail.com>
Subject: Re: bug? fstrim only trims unallocated space, not unused in bg's
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 20, 2017 at 9:43 PM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:

>
> And BTW, according to your sysfs discard output, it seems that you're
> using Intel 600P 256G NVME ssd, which I'm also using.

No. 'nvme list' shows it as:
SAMSUNG MZVLV256HCHP-000H1

And lscpi shows it as:
6d:00.0 Non-Volatile memory controller [0108]: Samsung Electronics Co
Ltd NVMe SSD Controller SM951/PM951 [144d:a802] (rev 01) (prog-if 02
[NVM Express])



-- 
Chris Murphy
