From: Dmitri Nikulin <dnikulin@gmail.com>
Subject: Re: metadata copied/data not copied?
Date: Tue, 17 Mar 2009 08:18:22 +1100
Message-ID: <3a7f57190903161418l790cae8ek9b48ff278e23de66@mail.gmail.com>
References: <200903161035.19446.csights@fastmail.fm>
	 <3a7f57190903161414s2118b763q9bad5ce1046b54e5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <3a7f57190903161414s2118b763q9bad5ce1046b54e5@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 17, 2009 at 8:14 AM, Dmitri Nikulin <dnikulin@gmail.com> wrote:
> Otherwise you could soft link
> /bin/sh into your home directly, setuid the link, and own the machine.

Sorry, that was a terrible example, only root can setuid anyway. A
better example is linking to /bin/sh and making your link writable,
then using that to inject malicious code, which is just as good and
would be possible with the semantics you described.

-- 
Dmitri Nikulin

Centre for Synchrotron Science
Monash University
Victoria 3800, Australia
