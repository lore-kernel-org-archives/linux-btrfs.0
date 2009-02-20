From: jim owens <jowens@hp.com>
Subject: Re: [PATCH] Backport for 2.6.27 and 2.6.26 on the experimental branch
Date: Fri, 20 Feb 2009 13:25:19 -0500
Message-ID: <499EF58F.6020807@hp.com>
References: <20090220174518.GA23955@tux64-01>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Lee Trager <lt73@cs.drexel.edu>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090220174518.GA23955@tux64-01>
List-ID: <linux-btrfs.vger.kernel.org>

lee,

A couple of thoughts about your .26 lockup:

- I assume you are on the same hardware with 27.

- Are you using a module or builtin btrfs (I build it in).

- It looks like you are using vmware... when I'm doing kernel
   stuff I want to be on the iron, not trusting virtual machine code.
   (people who use vmware tell me they have to rebuild vmware stuff
    even when they apply kernel patch distro updates)

- Compare your .26 and .27 configs, changes to default io sched
   or vm etc. can hurt or help you.

jim
