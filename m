Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f53.google.com ([209.85.216.53]:35911 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786Ab2JIMeH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Oct 2012 08:34:07 -0400
Received: by mail-qa0-f53.google.com with SMTP id s11so2824810qaa.19
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Oct 2012 05:34:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20121005204407.GA12424@localhost.localdomain>
References: <CALJXSJrtf7wid5xS4H5+E6ws_SjcgjB48ppoU_9+24JSkggKUw@mail.gmail.com>
	<CALJXSJoKW=7ev8obh3d_XYux0JjwJ+bVAwj_ps7Eih9eYxOQ3w@mail.gmail.com>
	<20121003205247.GO2370@localhost.localdomain>
	<CALJXSJrbe62q6XCOf5xB6ra1kwSOnVyL6DvYqS7ncyUQndfkgw@mail.gmail.com>
	<20121005174316.GQ2370@localhost.localdomain>
	<CALJXSJpxgjy6cEGhpnKQby0b_GE0XgajN9B5PSrLm7kZv7jtZw@mail.gmail.com>
	<20121005204407.GA12424@localhost.localdomain>
Date: Tue, 9 Oct 2012 08:34:06 -0400
Message-ID: <CALJXSJqJrVu2sU=s1_b05AZ4zQqjBMyNeV0s819VKcnCT7YYfA@mail.gmail.com>
Subject: Re: Out of memory condition
From: =?UTF-8?B?SsOpcsO0bWUgUG91bGlu?= <jeromepoulin@gmail.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Right now, with the patches applied on 3.5.0, Chrome didn't freeze
under out of memory conditions (2 OOM killer invocation).

On Fri, Oct 5, 2012 at 4:44 PM, Josef Bacik <jbacik@fusionio.com> wrote:
> On Fri, Oct 05, 2012 at 02:23:25PM -0600, Jérôme Poulin wrote:
>> I guess I'll be the guy who will test out of memory conditions! Here's
>> another stack further down the code.
>>
>
> Ok that was just a warning, did the box keep going after that?  I've fixed it up
> and sent a patch, unapply all the patches I've given you and apply the new ones
> I've just sent (there are 3) and see how that works for you.  If you don't get
> any BUG()'s but it's still hung then I'll need sysrq+w to see where you are
> hung, we probably screw up unlocking in these codepaths somewhere.  Thanks,
>
> Josef
