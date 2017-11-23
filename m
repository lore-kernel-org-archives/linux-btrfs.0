Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp73.iad3a.emailsrvr.com ([173.203.187.73]:51614 "EHLO
        smtp73.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752785AbdKWN6g (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 23 Nov 2017 08:58:36 -0500
Received: from smtp18.relay.iad3a.emailsrvr.com (localhost [127.0.0.1])
        by smtp18.relay.iad3a.emailsrvr.com (SMTP Server) with ESMTP id 1E63C252C5
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Nov 2017 08:58:36 -0500 (EST)
Received: by smtp18.relay.iad3a.emailsrvr.com (Authenticated sender: m.khalili-AT-rqc.ru) with ESMTPSA id CA87725289
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Nov 2017 08:58:35 -0500 (EST)
Subject: Re: notification about corrupt files from "btrfs scrub" in cron
To: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <1511380450.1675.94.camel@gmail.com>
 <pan$f10dc$17d1769f$63e482de$53d19a75@cox.net>
 <1511437679.14360.14.camel@gmail.com>
 <CAMU1PDj+ovqRXOrcnRkr8rP4L+e=g9FXeTmaKBHQ-2o+r2+5vw@mail.gmail.com>
From: Marat Khalili <mkh@rqc.ru>
Message-ID: <529fe690-b3c7-a63a-c574-4c4f443b4ba0@rqc.ru>
Date: Thu, 23 Nov 2017 16:58:37 +0300
MIME-Version: 1.0
In-Reply-To: <CAMU1PDj+ovqRXOrcnRkr8rP4L+e=g9FXeTmaKBHQ-2o+r2+5vw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 23/11/17 15:59, Mike Fleetwood wrote:

> Cron starts configured jobs at the scheduled time asynchronously.
> I.e. It doesn't block waiting for each command to finish.  Cron notices
> when the job finishes and any output produced, written to stdout and/or
> stderr, by the job is emailed to the user.  So no, a 2 hour job is not a
> problem for cron.

Minor additional advice -- prepend you command with:

> flock --nonblock /var/run/scrub.lock
to avoid running several scrubs simultaneously in case one takes more 
than 24 hours to finish.


--

With Best Regards,
Marat Khalili

