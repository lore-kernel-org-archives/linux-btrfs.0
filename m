From: Jeremy Sanders <jeremy@jeremysanders.net>
Subject: Re: [PATCH] Btrfs-progs use safe string manipulation functions
Date: Thu, 10 Feb 2011 11:37:01 +0000
Message-ID: <ij0iku$hbq$1@dough.gmane.org>
References: <1297081322.4615.10.camel@monotop> <4D53C711.3000309@nsc.liu.se> <AANLkTi=OaU8Wj+W2KuPZLbq_85_yVK9mTer9Q7hfTCUc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Olaf van der Spek wrote:

> On Thu, Feb 10, 2011 at 12:08 PM, Thomas Bellman <bellman@nsc.liu.se>
> wrote:
>> strncpy(args.name, source, BTRFS_PATH_NAME_MAX);
>> args.name[BTRFS_PATH_NAME_MAX] = '\0';
> 
> That's silly. Isn't there a sane safe variant of strcpy?

There's strlcpy, but it's not in glibc because of possible truncation 
errors!

http://en.wikipedia.org/wiki/Strlcpy

Of course C++ strings would be much better... :-)

Jeremy


