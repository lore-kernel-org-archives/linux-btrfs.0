From: Chris Samuel <chris@csamuel.org>
Subject: Re: [PATCH] btrfs: don't return EINTR
Date: Wed, 18 Apr 2012 09:39:17 +1000
Message-ID: <4F8DFF25.9070506@csamuel.org>
References: <1334408175-6568-1-git-send-email-sensille@gmx.net> <4F8D7B04.9050904@gmx.net> <20120417152401.GL28915@shiny> <20120417182219.GA4143@localhost.localdomain> <4F8DBCCB.10904@gmx.net> <20120417191424.GB4143@localhost.localdomain> <20120417193417.GU28915@shiny> <20120417193619.GC4143@localhost.localdomain> <20120417193843.GV28915@shiny> <4F8DC7C8.3070907@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F8DC7C8.3070907@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

On 18/04/12 05:43, Arne Jansen wrote:

> but not even the manpage states EINTR as return value from unlink.

Yeah, it's not mentioned in the Single UNIX Spec:

http://pubs.opengroup.org/onlinepubs/9699919799/functions/unlink.html

-- 
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC
