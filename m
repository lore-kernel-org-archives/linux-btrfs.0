Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58179 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197Ab3JGWmD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 7 Oct 2013 18:42:03 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r97Mg3f4018373
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 7 Oct 2013 18:42:03 -0400
Date: Mon, 7 Oct 2013 14:47:08 -0700
From: Zach Brown <zab@redhat.com>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 09/12] btrfs-progs: don't deref pipefd[-1]
Message-ID: <20131007214708.GG25712@lenny.home.zabbo.net>
References: <1381182185-10896-1-git-send-email-zab@redhat.com>
 <1381182185-10896-10-git-send-email-zab@redhat.com>
 <52532B5D.70302@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <52532B5D.70302@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 07, 2013 at 04:45:01PM -0500, Eric Sandeen wrote:
> On 10/7/13 4:43 PM, Zach Brown wrote:
> > commit 4782e8ebdb583dfa3615f7b38dee729d34f62ec1 accidentally replaced
> > [0] with [-1].  Put it back.  This was found by static analysis.
> > 
> > Signed-off-by: Zach Brown <zab@redhat.com>
> 
> eeehhhyeah.  Thanks for being charitable. ;)
> 
> Really, I have no idea how that happened.

I couldn't figure it out either.  The best I could come up with is that
one of the local XFS guys climbed in your office window and made the
change while you were at lunch.  In a black leotard with an awesome mask
and a black sack over their shoulder.

- z
