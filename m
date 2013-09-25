Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:39255 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755153Ab3IYMay (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Sep 2013 08:30:54 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id E261A9A06AA
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Sep 2013 06:30:53 -0600 (MDT)
Date: Wed, 25 Sep 2013 08:30:51 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Chris Murphy <lists@colorremedies.com>
CC: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: balance induced csum errors, systemd-journal
Message-ID: <20130925123051.GD18681@localhost.localdomain>
References: <4CA64610-C709-4805-A9DC-AA8EB0720BBF@colorremedies.com>
 <1810D553-8DB4-4FAA-A305-CF3BE9A85B6F@colorremedies.com>
 <F715552F-A1A0-49BE-B714-C5DF6B7D8AB6@colorremedies.com>
 <795CFB34-4216-4ACA-A56D-5F673B2FD45E@colorremedies.com>
 <013CDB89-72B2-4276-BCE9-0177CA90D840@colorremedies.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <013CDB89-72B2-4276-BCE9-0177CA90D840@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 24, 2013 at 11:44:15PM -0600, Chris Murphy wrote:
> 
> On Sep 24, 2013, at 10:34 PM, Chris Murphy <lists@colorremedies.com> wrote:
> 
> > And how would I go about setting /var/log/journal contents to inherit nodatacow? Possible?
> 
> chattr +C /var/log/journal
> 
> Resolved the problem. Whether this is an appropriate long term fix that systemd should apply to this directory, I don't know.
> 

That just disables cow which in turn disables csumming so it is a good solution
for you right now and gives me time ti figure out wtf is going on here.  Looking
at the systemd code it isn't doing O_DIRECT, which is how you usually end up
with this sort of situation.  So it is likely a bug on our side, I will try and
track it down today.  Thanks for narrowing this down,

Josef
