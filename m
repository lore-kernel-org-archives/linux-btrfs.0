From: Christian <cdysthe@gmail.com>
Subject: Re: Balancing takes "forever"
Date: Sat, 02 Jul 2011 15:59:57 -0500
Message-ID: <iuo0sf$t3f$1@dough.gmane.org>
References: <iulhuk$j0f$1@dough.gmane.org> <CAE5mzvib3TsOK+FH9URbmJyOpM0EJihnPyqNYah=mmsXfFxCeg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAE5mzvib3TsOK+FH9URbmJyOpM0EJihnPyqNYah=mmsXfFxCeg@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 07/02/2011 01:47 AM, cwillu wrote:

>
> Balance currently rewrites everything, and does it in a
> not-terribly-efficient way.  It's probably done by now (8 hours since
> your message), which isn't unusual.  There's some improvements in the
> pipeline, but they're not in a released kernel yet.

Thanks. That explains time used on this. It ended up taking around two 
hours. It also raises another question: Since I enabled compression 
after having used the file system for a while will all files that aren't 
compressed be compressed during the full balance process?

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

-- 
//Christian

