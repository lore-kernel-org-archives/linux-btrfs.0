From: Daniel J Blueman <daniel@quora.org>
Subject: Re: btrfs 3.2.2 -> 3.3.1 upgrade finally ate babies, some advice?
Date: Mon, 9 Apr 2012 22:35:49 +0800
Message-ID: <CAMVG2stk4skvQHCyKUzjV-WLJc8Emt0GjRBZBOK-_EJj4q-JYA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Linux BTRFS <linux-btrfs@vger.kernel.org>,
	Liu Bo <liubo2009@cn.fujitsu.com>
To: Leho Kraav <leho@kraav.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Leho Kraav <leho <at> kraav.com> writes:
[]
> Apr  8 02:46:11 s9 kernel: [  189.691778] attempt to access beyond end
> of device
> Apr  8 02:46:11 s9 kernel: [  189.691787] dm-3: rw=129, want=23361976,
> limit=20967424

I recently bumped into this too [1]. Liu Bo posted a patch for it [2],
which tests out fine here. The workaround is to not mount with
'discard' until eg ~3.4-rc3 or later.

Thanks,
  Daniel

[1] http://permalink.gmane.org/gmane.comp.file-systems.btrfs/16409
[2] http://permalink.gmane.org/gmane.comp.file-systems.btrfs/16649
-- 
Daniel J Blueman
