Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f43.google.com ([74.125.83.43]:59604 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754402AbaBSS5H (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Feb 2014 13:57:07 -0500
Received: by mail-ee0-f43.google.com with SMTP id e51so317103eek.30
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Feb 2014 10:57:06 -0800 (PST)
From: GEO <1g2e3o4@gmail.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Incremental backup over writable snapshot
Date: Wed, 19 Feb 2014 19:57:03 +0100
Message-ID: <3285782.sx6x1p7v9y@linuxpc>
In-Reply-To: <EEA604EA-983B-4F5F-88B5-4FD229FEC61F@colorremedies.com>
References: <17860756.QfG9CfNMqv@linuxpc> <EEA604EA-983B-4F5F-88B5-4FD229FEC61F@colorremedies.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wednesday 19 February 2014 10:00:49 Chris Murphy wrote:
> On Feb 19, 2014, at 6:45 AM, GEO <1g2e3o4@gmail.com> wrote:
> > I do not like the idea of making subvolumes of all directories I am not
> > interested in backing up.
> 
> Why? It addresses your use case.
> 
> Chris Murphy

I would prefer the idea of not snapshotting every directory I do not want to 
include, as there are almost more that I am not interested in. 

My question would simply be: Does the method going over the writeable snapshot 
and deleting things always lead to the same incremental end result as marking 
directories as snapshots that I am not interested in (apart from the 
additional empty directories created in case of the latter)?

Furthermore hidden directories in home change very often, meaning if I install 
additional software, additional hidden directories may be created.  So my 
script would have to mark them as snapshots every time.
If I have hidden files, I cannot mark files as snapshots, so it is clear that my 
method makes sense. 

Once I have marked these directories snapshots and I want to create snapshots 
of my whole home subvolume I would always additionally have to specify those.

So it makes the whole situation less manageable. 
Apart from that I find marking every directory I am not interested in as 
snapshots highly inelegant. 

So my question would be, if my preferred method is as reliable as the 
suggested method. 

Hope that's on the mailing list now :-). 


Thanks
