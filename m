Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:35214 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402AbcCYMsa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Mar 2016 08:48:30 -0400
Received: by mail-lb0-f179.google.com with SMTP id bc4so47978360lbc.2
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Mar 2016 05:48:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1458906560.3786108.559411242.3678497C@webmail.messagingengine.com>
References: <1458906560.3786108.559411242.3678497C@webmail.messagingengine.com>
From: Patrik Lundquist <patrik.lundquist@gmail.com>
Date: Fri, 25 Mar 2016 13:48:08 +0100
Message-ID: <CAA7pwKNj+qEUk+RhzyceRFqThzhUkroYMxS3b3gAn_5KEyawMQ@mail.gmail.com>
Subject: Re: Possible Raid Bug
To: Stephen Williams <stephenw@veryfast.biz>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 25 March 2016 at 12:49, Stephen Williams <stephenw@veryfast.biz> wrote:
>
> So catch 22, you need all the drives otherwise it won't let you mount,
> But what happens if a drive dies and the OS doesn't detect it? BTRFS
> wont allow you to mount the raid volume to remove the bad disk!

Version of Linux and btrfs-progs?

You can't have a raid10 with less than 4 devices so you need to add a
new device before deleting the missing. That is of course still a
problem with a read-only fs.

btrfs replace is also the recommended way to replace a failed device
nowadays. The wiki is outdated.
