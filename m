Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f52.google.com ([74.125.83.52]:44220 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754586AbaBTNUV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Feb 2014 08:20:21 -0500
Received: by mail-ee0-f52.google.com with SMTP id c41so77448eek.11
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Feb 2014 05:20:19 -0800 (PST)
From: GEO <1g2e3o4@gmail.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Incremental backup over writable snapshot
Date: Thu, 20 Feb 2014 14:20:16 +0100
Message-ID: <2091546.7UkK3HMHjX@linuxpc>
In-Reply-To: <EEA604EA-983B-4F5F-88B5-4FD229FEC61F@colorremedies.com>
References: <17860756.QfG9CfNMqv@linuxpc> <EEA604EA-983B-4F5F-88B5-4FD229FEC61F@colorremedies.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

@Kai Krakow: I accept your opinion and thank you for your answer.
However I have special reasons doing so. I could name you a few use cases. 
For example I do not need to backup search indexes as they mess up over time, 
so I simple recreate the cache in case of a new install. 
I know most of the settings I set and I know exactly what missing directories 
break what in case of deletion, because I have tried so various times.

This is not supposed to be a system backup, or a "home" backup, but a backup 
of my data (documents, videos etc.). 
I know hidden directories contain mails etc. but I know exactly where my mails 
are (most of them imap anyway) and I would include them in the backup. 

So I am looking for a different use case.

Anyway, I know most of you won't like my idea, but my question was, if I do 
everything right (and do not delete the wrong stuff out of stupidity), if the 
result would be as reliable as doing your approach, so please consider that as 
a technical question, even if you strongly dislike the idea.

So my initial question would remain: does the deleting of some stuff change the 
whole snapshot in a way, that the increment step would be screwed, which means 
I would back up blocks, that are not new. 
I do not have the expertise to check out the code and answer my question 
myself, so I would like to hear the opinion of the devs whether my way should 
work in theory or not, regardless of the fact that the use case has not been 
tested and is not recommended. 

Thank you very much for your opinions.
