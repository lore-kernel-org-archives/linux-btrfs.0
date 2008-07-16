From: Josef Bacik <jbacik@redhat.com>
Subject: Re: QA suite plans
Date: Wed, 16 Jul 2008 08:05:40 -0400
Message-ID: <20080716120540.GH30311@unused.rdu.redhat.com>
References: <3da3b5b40807160139w4b8e3474te113980d0086ba9c@mail.gmail.com> <3da3b5b40807160206h1e07033fu3fba59fd5edd7aa1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Ahmed Kamal <email.ahmedkamal@googlemail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <3da3b5b40807160206h1e07033fu3fba59fd5edd7aa1@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 16, 2008 at 12:06:00PM +0300, Ahmed Kamal wrote:
> Hi Team,
> I have been following the btrfs project since Chris announced it last
> year. I am happy to see v1.0 is planned in Q4. This is awesome, we can
> finally get something like ZFS on Linux. The project pace is nothing
> short of amazing. Thank you :)
> 
> I notice the plans contain "QA suite".
> I would like to ask if there are any written plans for this QA suite yet ?
> Is the suite going to be kernel code, or is it basically going to be a
> set of scripts using btrfs userspace commands for regression testing ?

AFAIK its going to be alot like the xfs stuff, where its just a bunch of scripts
to test for regressions.  So stuff to test the subvol/snapshotting stuff, and
then other scripts to test the normal filesystem aspects of btrfs.  Thanks,

Josef
