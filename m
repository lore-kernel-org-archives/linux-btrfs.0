From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: Create subvolume from a directory?
Date: Wed, 28 Mar 2012 08:46:13 +0700
Message-ID: <CAG1y0sd9o07nckBzDPsG3w3BmFaByNxfAqQYWwf2Uzq2j1iZCA@mail.gmail.com>
References: <loom.20120327T190041-268@post.gmane.org>
	<20120327222422.GA32675@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Alex <alex@bpmit.com>, linux-btrfs@vger.kernel.org
To: "Matthias G. Eckermann" <mge@suse.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120327222422.GA32675@suse.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 28, 2012 at 5:24 AM, Matthias G. Eckermann <mge@suse.com> wrote:
> While the time measurement might be flawed due to the subvol
> actions inbetween, caching etc.: I tried several times, and
> "cp --reflinks" always is multiple times faster than "mv" in
> my environment.

So this is cross-subvolume reflinks? I thought the code for that
wasn't merged yet?

-- 
Fajar
