Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:59058 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754500Ab3C2N5Z (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Mar 2013 09:57:25 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 80BDC7C042F
	for <linux-btrfs@vger.kernel.org>; Fri, 29 Mar 2013 07:57:25 -0600 (MDT)
Date: Fri, 29 Mar 2013 09:57:23 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: =?iso-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
CC: Josef Bacik <JBacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: scrub "correcting" tons of errors ?
Message-ID: <20130329135723.GE1876@localhost.localdomain>
References: <515563D7.3020706@petaramesh.org>
 <20130329125832.GB1876@localhost.localdomain>
 <515591D9.5010802@petaramesh.org>
 <20130329132603.GD1876@localhost.localdomain>
 <5155997A.9020301@petaramesh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
In-Reply-To: <5155997A.9020301@petaramesh.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 29, 2013 at 07:39:06AM -0600, Swâmi Petaramesh wrote:
> Le 29/03/2013 14:26, Josef Bacik a écrit :
> > after you've run sysrq+w and then reply with the URL it spits out.  Thanks,
> I'm afraid I won't be able to do this this afternoon : I also need to
> work on my machine ;-) so for now I will avoid to restart a scrub that
> would possibly crash it once more...
> 
> I'll hopefully be back on this soon.
> 

Yeah that picture was enough, I see what's going on, I'll send a patch.  Thanks,

Josef
