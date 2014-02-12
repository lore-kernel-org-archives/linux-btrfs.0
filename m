Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36855 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbaBLDz6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Feb 2014 22:55:58 -0500
Message-ID: <52FAF0C8.9060908@oracle.com>
Date: Wed, 12 Feb 2014 11:55:52 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: "lin >> \"linux-btrfs@vger.kernel.org\""
	<linux-btrfs@vger.kernel.org>
CC: Josef Bacik <jbacik@fb.com>
Subject: Re: What to do about df and btrfs fi df
References: <52F9014F.6070901@fb.com>
In-Reply-To: <52F9014F.6070901@fb.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



  Most of the btrfs-progs output has to be (re)designed from the point
  of view of the end-user.

  Eg: 'btrfs su list /mnt', it could have been much better from the end
  user perspective (who does not have to look into the source code),
  of course it does make sense to the developers himself but that's
  irrelevant.  And the good news its getting better.

  When creating btrfs-progs output, it has to match with the context
  that end user will be when using btrfs. And, advance details could
  go into the --verbose/--debug option.


Thanks, -Anand
