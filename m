Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:50970 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752612Ab3LUDJI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Dec 2013 22:09:08 -0500
Date: Sat, 21 Dec 2013 12:08:56 +0900
From: Tomasz Chmielewski <tch@virtall.com>
To: Shilong Wang <wangshilong1991@gmail.com>
Cc: Wang Shilong <wangsl.fnst@cn.fujitsu.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: kernel BUG at fs/btrfs/relocation.c:1062
Message-ID: <20131221120856.417ab384@virtall.com>
In-Reply-To: <CAP9B-Q=rmMssHkNsypKmqcFdVgnT=hPsZSgdvq57v+P_XaCH9A@mail.gmail.com>
References: <20131219210941.1065d1b5@virtall.com>
	<52B2E319.4010706@cn.fujitsu.com>
	<20131219213019.1f1038f2@virtall.com>
	<52B2EB40.5090904@cn.fujitsu.com>
	<20131219220737.7b173f9a@virtall.com>
	<20131221000623.30148a5d@virtall.com>
	<CAP9B-Qm+he3V-Oh2AgH+gUXgcSUbE-Az0YaW0gBgW03mmDN9EA@mail.gmail.com>
	<20131221005902.0d795572@virtall.com>
	<CAP9B-Q=SyEbQP1fLto2buR7jRqQHcD37ACuAguSxT4Td07KV9Q@mail.gmail.com>
	<20131221014110.606c2ca8@virtall.com>
	<CAP9B-Q=rmMssHkNsypKmqcFdVgnT=hPsZSgdvq57v+P_XaCH9A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 21 Dec 2013 01:11:00 +0800
Shilong Wang <wangshilong1991@gmail.com> wrote:

> ok, It seems that your filesystem is not in consistency anymore.
> To confirm your filesystem status, you can try to run btrfsck to
> check if there is something wrong.
> 
> To get a stable fs now, you can try to mount btrfs with option
> skip_balance and recovery, recovery options try to get a previous
> good tree root which might help you
> get a stable fs.

Unfortunately even after using these mount options it breaks as before,
as soon as I remove snapshots, or even copy some data in with rsync.

Oh well, at least I have read only access...


-- 
Tomasz Chmielewski
http://wpkg.org
