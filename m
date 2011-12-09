From: Arne Jansen <sensille@gmx.net>
Subject: Re: Btrfs switches to using mostly one thread
Date: Fri, 09 Dec 2011 13:15:33 +0100
Message-ID: <4EE1FBE5.2090602@gmx.net>
References: <jbqkib$v1g$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Jeremy Sanders <jeremy@jeremysanders.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <jbqkib$v1g$1@dough.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

On 08.12.2011 16:19, Jeremy Sanders wrote:
> Hi - I'm trying out btrfs again, and I see the same old bug in kernel 3.1.4 
> (Fedora 16, x86_64, dual-core), where after a few hours of writing, it 
> switches from writing with several threads to writing with one:

How many disks does the fs have?

-Arne
