Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60883 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755817Ab3AYPHU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Jan 2013 10:07:20 -0500
Message-ID: <51029FA0.10608@redhat.com>
Date: Fri, 25 Jan 2013 09:07:12 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Gene Czarcinski <gene@czarc.net>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: Exit if not running as root
References: <1359113550-23962-1-git-send-email-gene@czarc.net>
In-Reply-To: <1359113550-23962-1-git-send-email-gene@czarc.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 1/25/13 5:32 AM, Gene Czarcinski wrote:
> This patch hits a lot of files but adds little code.  It
> could be considered a bugfix,  Currently, when one of the
> btrfs user-space programs is executed by a regular user,
> the result if oftem a number of strange error messages
> which do not indicate the real problem.  This patch changes
> that situation.
> 
> A test is performed as to whether the program is running
> as root.  If it is not, issue an error message and exit.
> Signed-off-by: Gene Czarcinski <gene@czarc.net>
> ---

I agree with others that this isn't the right approach, I'm
afraid.

But can we back up a little - 

>> Currently, when one of the
>> btrfs user-space programs is executed by a regular user,
>> the result if oftem a number of strange error messages
>> which do not indicate the real problem.

Can you elaborate on what situations those are, and what
messages appear?  I'm guessing that it just requires some
error handling fixes.

-Eric
