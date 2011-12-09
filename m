From: Jeremy Sanders <jeremy@jeremysanders.net>
Subject: Re: Btrfs switches to using mostly one thread
Date: Fri, 09 Dec 2011 12:20:52 +0000
Message-ID: <4EE1FD24.5090700@jeremysanders.net>
References: <jbqkib$v1g$1@dough.gmane.org> <4EE1FBE5.2090602@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Arne Jansen <sensille@gmx.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EE1FBE5.2090602@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

On 09/12/11 12:15, Arne Jansen wrote:
> On 08.12.2011 16:19, Jeremy Sanders wrote:
>> Hi - I'm trying out btrfs again, and I see the same old bug in kernel 3.1.4
>> (Fedora 16, x86_64, dual-core), where after a few hours of writing, it
>> switches from writing with several threads to writing with one:
>
> How many disks does the fs have?

One - it's writing onto a "linear" MD array (for testing purposes). I 
disabled duplication of metadata as well, and zlib compression is forced.

Jeremy

