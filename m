Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:63843 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750797Ab3IYFoX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Sep 2013 01:44:23 -0400
Received: from c-67-165-243-162.hsd1.co.comcast.net ([67.165.243.162]:53901 helo=[192.168.1.126])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.80.1)
	(envelope-from <lists@colorremedies.com>)
	id 1VOhtZ-002XGA-P1
	for linux-btrfs@vger.kernel.org; Tue, 24 Sep 2013 23:44:17 -0600
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: balance induced csum errors, systemd-journal
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <795CFB34-4216-4ACA-A56D-5F673B2FD45E@colorremedies.com>
Date: Tue, 24 Sep 2013 23:44:15 -0600
Message-Id: <013CDB89-72B2-4276-BCE9-0177CA90D840@colorremedies.com>
References: <4CA64610-C709-4805-A9DC-AA8EB0720BBF@colorremedies.com> <1810D553-8DB4-4FAA-A305-CF3BE9A85B6F@colorremedies.com> <F715552F-A1A0-49BE-B714-C5DF6B7D8AB6@colorremedies.com> <795CFB34-4216-4ACA-A56D-5F673B2FD45E@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Sep 24, 2013, at 10:34 PM, Chris Murphy <lists@colorremedies.com> wrote:

> And how would I go about setting /var/log/journal contents to inherit nodatacow? Possible?

chattr +C /var/log/journal

Resolved the problem. Whether this is an appropriate long term fix that systemd should apply to this directory, I don't know.

Chris Murphy

