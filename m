From: Ilya Dryomov <idryomov@gmail.com>
Subject: Re: [PATCH v2] Btrfs, lockdep: get_restripe_target: use lockdep in
 BUG_ON
Date: Thu, 5 Apr 2012 19:51:48 +0300
Message-ID: <20120405165148.GA2595@zambezi.lan>
References: <1333570774-26462-1-git-send-email-bobbypowers@gmail.com>
 <1333591452-23264-1-git-send-email-bobbypowers@gmail.com>
 <CAArOQ2Vc35VnbTCAZigTGZ3pL-f8mAtA9Ugpdjo5S=M7Ujpeiw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
	Andi Kleen <ak@linux.intel.com>, Jeff Mahoney <jeffm@suse.de>,
	Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
To: Bobby Powers <bobbypowers@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAArOQ2Vc35VnbTCAZigTGZ3pL-f8mAtA9Ugpdjo5S=M7Ujpeiw@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 05, 2012 at 12:23:01PM -0400, Bobby Powers wrote:
> On Wed, Apr 4, 2012 at 10:04 PM, Bobby Powers <bobbypowers@gmail.com>=
 wrote:
> > spin_is_locked always returns 0 on non-SMP systems, which causes bt=
rfs
> > to fail the mount. =C2=A0There is documentation pending as to why c=
hecking
>=20
> I guess I should be explicit in stating that this is a regression, so
> this patch or something else that addresses it should be pulled into
> 3.4.

Yes, this is a regression and spin_is_locked() definitely has to go.  I
don't have a strong opinion on this assert, if there are objections to
v2 I'm OK with ripping that BUG_ON entirely and replacing it with a
comment (this function and its callers are WIP).

Thanks,

		Ilya
