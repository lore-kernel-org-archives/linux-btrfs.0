From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH v0 03/18] btrfs: add nested locking mode for paths
Date: Thu, 6 Oct 2011 22:50:45 +0200
Message-ID: <20111006205045.GU14482@one.firstfloor.org>
References: <cover.1317915010.git.sensille@gmx.net> <55d5758142bf964aefbbaadc2188f66ca178f876.1317915010.git.sensille@gmx.net> <m2ty7l3lji.fsf@firstfloor.org> <CANvN+ems8D+wB_YPzoNpsqxZ8on-z7xCEXQuQ0LgoF_T=gw+Yw@mail.gmail.com> <CANvN+emRvTQD-epGJrELs_WAF06zuuBb0ELpSFrGazzAbo29gg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andi Kleen <andi@firstfloor.org>, chris.mason@oracle.com,
	Arne Jansen <sensille@gmx.net>, linux-btrfs@vger.kernel.org
To: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CANvN+emRvTQD-epGJrELs_WAF06zuuBb0ELpSFrGazzAbo29gg@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 07, 2011 at 12:44:30AM +0400, Andrey Kuzmin wrote:
> Perhaps you could just elaborate on "needs this feature"? In general, write
> lock gives one exclusive access, so the need for additional read
> (non-exclusive) lock does not appear easily understandable.

Usually it's because the low level code can be called both with and
without locking and it doesn't know.

But that usually can be avoided with some restructuring.

-Andi
