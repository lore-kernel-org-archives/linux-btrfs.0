Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:48901 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932292Ab2JLMwF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Oct 2012 08:52:05 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: Varying Leafsize and Nodesize in Btrfs
Date: Fri, 12 Oct 2012 14:52:03 +0200
Cc: Mitch Harder <mitch.harder@sabayonlinux.org>
References: <CAKcLGm_MKEdTiHFBd-b-v2sN5gJmgFRqsykzWRXTVqUw4O6Acw@mail.gmail.com> <201210121232.55415.Martin@lichtvoll.de> (sfid-20121012_130619_891962_9D9D5E27)
In-Reply-To: <201210121232.55415.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201210121452.03569.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Freitag, 12. Oktober 2012 schrieb Martin Steigerwald:
> > Time (seconds) to finish 7 simultaneous copy operations on a set of
> > Linux kernel git sources.
> >
> > 
> >
> > Leafsize/
> > Nodesize    Time (Std Dev%)
> > 4096         124.7 (1.25%)
> > 8192         115.2 (0.69%)
> > 16384        114.8 (0.53%)
> > 65536        130.5 (0.3%)
> 
> Thanks for your testing, Mitch.
> 
> I would be interested in results for 32768 bytes as well.
> 
> Why?
> 
> It improves until 16384 bytes but then it gets worse with 65536 bytes.
> It  would be interesting to know whether it improves for 32768 or
> already gets worse with that value :)

Please ignore. I was answering to a old thread that was shown on top of 
message list to answer to Phillip again. We had that topic already.

Sorry for noise.

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
