From: David Pottage <david@electric-spoon.com>
Subject: Re: btrfs problems and fedora 14
Date: Fri, 26 Nov 2010 10:36:11 +0000
Message-ID: <4CEF8D9B.8070306@electric-spoon.com>
References: <1290467983.24502.66.camel@main-wireless>	<AANLkTinuQU46BCL6WLM4hEc+ocXsbOGHoF3ppGbTOc8y@mail.gmail.com>	<AANLkTimkdtmjeO1Hzq5y1nL_ERNiJS1S0xn6Vu2_yyj=@mail.gmail.com>	<1290583953.2235.28.camel@main-wireless>	<AANLkTimhA5z8xB_t9bGCC4=jzezPhHTPzBPy=0PW9Kpg@mail.gmail.com>	<1290764456.4380.20.camel@main-wireless> <03d3ps1jjj.fsf@msgid.viggen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <03d3ps1jjj.fsf@msgid.viggen.net>
List-ID: <linux-btrfs.vger.kernel.org>

On 26/11/10 10:11, Oystein Viggen wrote:
> What would be really awesome is some sort of "btrfs-send" program that
> handles all this the best way for you, but I don't think that exists
> (yet).  User friendly tools will undoubtedly appear as btrfs is more
> used, but I guess it's still partly in the "roll your own" early adopter
> stage.  :)
>    
I agree.

In the past this sort of thing has been handled by adding features to 
tar, so that tar 'knows' how to pack up a filesystem with the latest new 
features (extended meta data for example), and how to restore that data 
at the other end.

-- 
David Pottage.

