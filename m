Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:37408 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932522Ab3CGSK2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Mar 2013 13:10:28 -0500
Message-ID: <5138D80F.1080304@petaramesh.org>
Date: Thu, 07 Mar 2013 19:10:23 +0100
From: =?UTF-8?B?U3fDom1pIFBldGFyYW1lc2g=?= <swami@petaramesh.org>
MIME-Version: 1.0
To: =?UTF-8?B?SsOpcsO0bWUgUG91bGlu?= <jeromepoulin@gmail.com>
CC: Eric Sandeen <sandeen@redhat.com>,
        "BTRFS, Linux" <linux-btrfs@vger.kernel.org>,
        Anand Jain <Anand.Jain@oracle.com>
Subject: Re: mkfs.btrfs broken
References: <513883DD.8080203@petaramesh.org> <5138980C.8080000@redhat.com> <5138ADA6.5070101@petaramesh.org> <5138AE96.3020304@redhat.com> <5138B08F.70607@petaramesh.org> <CALJXSJrbF678ghk63P=m2wc5NGnRjrvk2cGMqSnKHXzXG+i3Tg@mail.gmail.com>
In-Reply-To: <CALJXSJrbF678ghk63P=m2wc5NGnRjrvk2cGMqSnKHXzXG+i3Tg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 07/03/2013 19:06, Jérôme Poulin a écrit :
> mkfs.btrfs tries to lookup loop devices by their filenames and fails
> if any loop device file is missing.

Hmm.... Why would mkfs.btrfs want to lookup anything else but the device
we're trying to format, to check if it's mounted or not ?

-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E
Ne cherchez pas : Je ne suis pas sur Facebook.

