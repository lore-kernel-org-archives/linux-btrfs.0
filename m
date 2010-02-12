From: Mike Fedyk <mfedyk@mikefedyk.com>
Subject: Re: Kernel BUG on mounting BtrFS / after reboot
Date: Fri, 12 Feb 2010 14:50:59 -0800
Message-ID: <93cdabd21002121450i75586f4ahfe658e4db9204a8e@mail.gmail.com>
References: <loom.20100212T220341-877@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Alex Elsayed <eternaleye@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <loom.20100212T220341-877@post.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 12, 2010 at 1:04 PM, Alex Elsayed <eternaleye@gmail.com> wrote:
> I'm getting a rather nasty BUG when I try to mount this filesystem,
> _including_ when I specify -o ro. I'm unsure what caused it, but the problem
> manifested after my computer hardlocked while reading my RSS feeds, complete
> with flashing lights. After I rebooted it, the screen filled with panic
> messages when the initramfs tried to mount it RO to pivot into. I am running
> 2.6.33-rc6. The BUG message is as follows:

Is this the bug you mentioned on IRC that you fixed somehow?

If so please post the steps you performed.
