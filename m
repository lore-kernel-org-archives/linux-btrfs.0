From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: Rename BTRfs to MuchSlowerFS ?
Date: Mon, 05 Sep 2011 18:23:23 +0200
Message-ID: <4E64F77B.1090401@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

>    That's because dpkg is known for using (f)sync very heavily.  btrfs
> honours the sync request in all cases, so it's much much slower than
> ext3, which doesn't.

Hmm, is it really the case with ext3/ext4 (ignoring fsync in some cases)?

Sounds like a bug in ext3/ext4 then.

Is it documented anywhere where ext3/ext4 would just silently ignore fsync?


-- 
Tomasz Chmielewski
http://wpkg.org

