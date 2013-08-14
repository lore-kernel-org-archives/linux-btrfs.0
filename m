Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44454 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933153Ab3HNXRU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Aug 2013 19:17:20 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r7ENHKEN030711
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 14 Aug 2013 19:17:20 -0400
Received: from lenny.home.zabbo.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id r7ENHKSj017824
	for <linux-btrfs@vger.kernel.org>; Wed, 14 Aug 2013 19:17:20 -0400
From: Zach Brown <zab@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [RFC] btrfs-progs: fix sparse checking and warnings
Date: Wed, 14 Aug 2013 16:16:30 -0700
Message-Id: <1376522205-16992-1-git-send-email-zab@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi gang,

I was a little surprised to see that patch go by recently 
which fixed an endian bug.  I went to see how sparse
checking looked and it was.. broken.  I got it going
again in my Fedora environment.

Most of the patches are just cleanups, but there *were*
three real bugs lurking in all that sparse warning spam.
So I maintain that it's worth our time to keep it going
and fix warnings so that we have a chance of finding these
real bugs before users do.

I've only just built this and I haven't checked that it
doesn't break the build during bisection.  I wanted to
let people see it before getting too lost fiddling with it.
Dave, I'm happy to rework this as needed to get it integrated.

FWIW, it's worth running a locally built sparse from its
current git tree to avoid unknown attribute warnings.

-z

