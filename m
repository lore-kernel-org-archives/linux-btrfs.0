Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32459 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237AbbK0ImL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Nov 2015 03:42:11 -0500
From: Anand Jain <anand.jain@oracle.com>
Subject: Re: [PATCH 0/7] Let user specify the kernel version for features
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        linux-btrfs@vger.kernel.org
References: <1448453300-8449-1-git-send-email-anand.jain@oracle.com>
 <5656683C.6060001@cn.fujitsu.com> <5656A18E.9050607@oracle.com>
 <5656AC64.3030304@cn.fujitsu.com> <5656EA7F.1070500@oracle.com>
 <5656FBB7.5020802@gmx.com> <565784DE.5080401@oracle.com>
 <5657A757.90909@cn.fujitsu.com>
Cc: dsterba@suse.cz, calestyo@scientia.net, ahferroin7@gmail.com,
        1i5t5.duncan@cox.net
Message-ID: <56581742.9030308@oracle.com>
Date: Fri, 27 Nov 2015 16:41:38 +0800
MIME-Version: 1.0
In-Reply-To: <5657A757.90909@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>





> I meant, it can be done in packaging level and it's much easier to do.

  Its all about trade off, and there is no right or wrong, so is tough
  to arrive at a conclusion even before this was implemented. Below are
  the choices considered, now putting in the order of least suitable
  to most suitable after reviewing their advantages and disadvantages.

  . Update default features at the compile time, so to have a define
    set for the default choices per release/distro. (not sure how to
    do that), But with this, you can not solve the problem for which
    current "-O comp=" is provided (i.e to provide features which are
    compatible across a set of known kernels). And mainly, you are
    letting the control of such a discussion out of btrfs/mainline.
    Then distros will have own set of default features instead of having
    such an effort discussed and converged at the mainline.

  . /etc/btrfs.conf file to hold the default features (same as ext4)
    I have to drop this idea since from the user point of view you are
    creating another source of config/input that user/distro has to
    care about.

  . Do it at run time for the running kernel. Current. In the order of
    priority .. check sysfs, if not check kernel-version, if not use
    progs-version-based-defaults (original).


> And it's much predictable than version based detection.

  I think you mean to say its not predictable because it follows
  a priority list, and we won't know which system used sysfs/version/
  progs-version. Concern is valid. But I feel its trivial, unless
  you have some strong reason. Further still its only a trade off that
  could achieve.

  Other concern that others commented..

  if sysfs is not there and feature is backported, for this we should
  ensure sysfs feature is also backported along with the feature it
  self, without that feature back port is incomplete. If distro does not
  want to backport sysfs, the other choice that disto has is to update
  the feature-to-version table in the progs.

  For the system which does not provide version at all, it will fail
  back to the original progs-version-based-defaults.


  Hope I have captured all the concerns and addressed them.


Thanks, Anand


