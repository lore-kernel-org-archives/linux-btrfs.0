Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17697 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751070Ab3CRQTJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Mar 2013 12:19:09 -0400
Message-ID: <51473E87.7020507@redhat.com>
Date: Mon, 18 Mar 2013 11:19:19 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Anand Jain <anand.jain@oracle.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: return zero for success
References: <1363591441-6335-1-git-send-email-anand.jain@oracle.com> <51473E55.9010100@redhat.com>
In-Reply-To: <51473E55.9010100@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 3/18/13 11:18 AM, Eric Sandeen wrote:
> On 3/18/13 2:24 AM, Anand Jain wrote:
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> 
> 
> You've got your testcase leaking into this defrag fix.
> 
> When you resend, can you add "defrag" to the patch subject somehow?
> 
> -Eric

Ugh,sorry.  Should read all new list email before replying. 
I see that you did this already.  Nevermind.

-Eric

