Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22405 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752366Ab3EaGYd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 31 May 2013 02:24:33 -0400
Date: Thu, 30 May 2013 23:24:30 -0700
From: Zach Brown <zab@redhat.com>
To: Chris Mason <chris.mason@fusionio.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: testing stable pages being modified
Message-ID: <20130531062430.GB24721@lenny.home.zabbo.net>
References: <20130530223610.GA24721@lenny.home.zabbo.net>
 <20130531051158.7927.24213@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130531051158.7927.24213@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> Changing O_DIRECT in flight has always been a deep dark corner case, and
> crc errors are the expected result.  Have you found anyone doing this in
> real life?

Agreed; and no, I haven't heard of people accidentally modifying stable
pages.

> I do like the small test program though, we should extend it into a test
> to make sure crcs are really crcing.

Yeah, the little test is more to make sure that the error paths handle
the modification case as expected :).

- z
