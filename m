Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45146 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054Ab2GOCJj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 14 Jul 2012 22:09:39 -0400
Received: by pbbrp8 with SMTP id rp8so7887898pbb.19
        for <linux-btrfs@vger.kernel.org>; Sat, 14 Jul 2012 19:09:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAF7mNP4oQ=sSXf-gVSMF2Xq89OL25L7HnWL4MbqSONxr8=RRTQ@mail.gmail.com>
References: <CAF7mNP4oQ=sSXf-gVSMF2Xq89OL25L7HnWL4MbqSONxr8=RRTQ@mail.gmail.com>
Date: Sat, 14 Jul 2012 20:09:38 -0600
Message-ID: <CAE5mzvhs58U-WCheev=SjtAGk3YFZNnd1tkc6CbXheY5ndrmAA@mail.gmail.com>
Subject: Re: bug: raid10 filesystem has suddenly ceased to mount
From: cwillu <cwillu@cwillu.com>
To: =?UTF-8?B?0JjQstCw0L0g0KHQvNC40YDQvdC+0LI=?=
	<feliz.cha.cha.cha@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Try -o recovery under a 3.4 or later kernel

On Sat, Jul 14, 2012 at 12:48 AM, Иван Смирнов
<feliz.cha.cha.cha@gmail.com> wrote:
> Hi!
> The problem is that the BTRFS raid10 filesystem without any
> understandable cause refuses to mount.
> Here is dmesg output:
> [77847.845540] device label linux-btrfs-raid10 devid 3 transid 45639 /dev/sdc1
> [77848.633912] btrfs: allowing degraded mounts
> [77848.633917] btrfs: enabling auto defrag
> [77848.633919] btrfs: use lzo compression
> [77848.633922] btrfs: turning on flush-on-commit
> [77848.658879] parent transid verify failed on 2363592273920 wanted
> 31596 found 25250
> [77848.659060] parent transid verify failed on 2363592273920 wanted
> 31596 found 25250
> [77848.659274] parent transid verify failed on 2363592273920 wanted
> 31596 found 25250
> [77848.659455] parent transid verify failed on 2363592273920 wanted
> 31596 found 25250
> [77848.659459] parent transid verify failed on 2363592273920 wanted
> 31596 found 25250
> [77848.659464] btrfs: failed to read chunk tree on sdc1
> [77848.661376] btrfs: open_ctree failed
>
> Linux kernel: 3.3.0-3-grml-amd64
> Distribution: Debian (mix of stable and testing branches with grml kernel).
> S.M.A.R.T. of all drives is good.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
