Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:31292 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753445Ab3JKOHi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Oct 2013 10:07:38 -0400
Message-ID: <52580629.90307@giantdisaster.de>
Date: Fri, 11 Oct 2013 16:07:37 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fail device statistic reset on read-only filesystem
References: <2a649d6a51055ac36352a73add403037acc537ef.1381493768.git.sbehrens@giantdisaster.de> <20131011134733.GA5095@localhost.localdomain>
In-Reply-To: <20131011134733.GA5095@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 11 Oct 2013 09:47:33 -0400, Josef Bacik wrote:
> Hey look something else that should go into xfstests,

I don't think so. It's a bug that is there from the very beginning, not
a regression. We can't catch all possible errors (non-regressions) with
xfstests. We would spend all time for writing xfstests, there wouldn't
be any time left to actually add bugs.


