From: Marti Raudsepp <marti@juffo.org>
Subject: Re: btrfs: compression breaks cp and cross-FS mv, FS_IOC_FIEMAP bug?
Date: Sun, 13 Feb 2011 18:07:36 +0200
Message-ID: <AANLkTi=Rj_3MmLawJj-K8u+pGbT_NZzqzVGFOsvOK8eC@mail.gmail.com>
References: <AANLkTinZNk1j94rEMVdvRtjr2Sa-C7VpQOGHrvrY8Hph@mail.gmail.com> <20110213155730.GK19533@dhcp231-156.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: btrfs hackers <linux-btrfs@vger.kernel.org>,
	Kernel hackers <linux-kernel@vger.kernel.org>
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110213155730.GK19533@dhcp231-156.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Feb 13, 2011 at 17:57, Josef Bacik <josef@redhat.com> wrote:
> Does the same problem happen when you use cp --sparse=never?

You are right. cp --sparse=never does not cause data loss.

Regards,
Marti
