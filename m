Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:24467 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753952Ab3LDSKA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 4 Dec 2013 13:10:00 -0500
Date: Wed, 4 Dec 2013 09:49:09 -0800
From: Josef Bacik <jbacik@fb.com>
To: Adam Gradzki <adam.gradzki@gmail.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs-cleaner leaves CPU pinned to 100%
Message-ID: <20131204174909.GA6675@fb.com>
References: <CALnfhZDKEs7LeTrHAk3oecJ2oOqo=VJzQqoeEy3qNB92s2CC7A@mail.gmail.com>
 <loom.20131204T162331-814@post.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <loom.20131204T162331-814@post.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Adam Gradzki <adam.gradzki@gmail.com> wrote on Wed [2013-Dec-04 15:27:58 +0000]:
> Adam G <adam.gradzki <at> gmail.com> writes:
> 
> > 
> > Hello,
> > 
> > After a recent kernel upgrade I noticed the fans blowing at full
> > throttle on my laptop.
> > 
> > There is currently very low load on the machine and nothing out of the
> > ordinary has occurred to lead me to believe this is normal behavior.
> > 
> > Here is a link to the perf output I managed to capture
> > 
> > http://pastebin.com/a5cAy7Dw
> > 
> > Please let me know if I may be of any further assistance.
> > 
> > Regards,
> > 
> > Adam Gradzki
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> > the body of a message to majordomo <at> vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> > 
> 
> I would like to add an updated perf report I took shortly after the first 
> one yesterday (600 seconds this time).
> 
> http://www.pastebin.ca/2492119
> 
> Removing autodefrag from /etc/fstab has ameliorated my troubles for the time 
> being.
> 

Do you have a lot of snapshots?  I'm working on this currently so hopefully it
will be fixed soon.  If you have issues again can you use perf record -g so it
pulls the stacktraces and then you can drill down before you post so I can
figure out where we're spending all of our time.  Thanks,

Josef
