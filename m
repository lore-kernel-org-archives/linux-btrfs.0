From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: Can't mount, power failure - recoverable?
Date: Mon, 26 Mar 2012 15:56:45 +0700
Message-ID: <CAG1y0scA0bRfLfJsTpOn9kDVQrf3Ncu8eLKmOkj142YMEmcjwg@mail.gmail.com>
References: <loom.20120317T051243-551@post.gmane.org>
	<CAE5mzvi8oX4B+yriTRnj_g+_a3=BoC-o1BSRs4PpJsAMBOP5xw@mail.gmail.com>
	<loom.20120317T192345-893@post.gmane.org>
	<20120318151615.GE3976@shiny>
	<loom.20120318T193113-459@post.gmane.org>
	<20120319180235.GH3976@shiny>
	<loom.20120320T035257-31@post.gmane.org>
	<loom.20120326T103140-428@post.gmane.org>
	<CAG1y0sdg18Dv2YA_WDRSYp3eGTHO-V2xx99OXxDJQx=O4qqgHA@mail.gmail.com>
	<loom.20120326T104619-458@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Skylar Burtenshaw <daninfuchs@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <loom.20120326T104619-458@post.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 26, 2012 at 3:49 PM, Skylar Burtenshaw <daninfuchs@gmail.com> wrote:
> Fajar A. Nugraha <list <at> fajar.net> writes:
>
>> Didn't Chris' last response basically say "use kernel 3.2 or newer,
>> mount the fs (possibly with -o ro), and copy the data elsewhere"?
>
> Why yes, yes it did actually. I appreciate your spotlighting it, just in case I
> somehow managed to miss it, though.
>
>> Have you done that?
>
> I have. In fact, in my first message, I stated that in all kernels up to present
> 3.2 kernels, I get several minutes of disk churning, then a stack trace. Also
> present in my messages is the fact that the filesystem will not mount, as well
> as data output from the recovery program etc which fail to recognize things in
> the filesystem that they require in order to fix it. Did you have something you
> wished to suggest, in order to help me? If so, I'd gladly listen to any proposed
> ideas.

Since you apprently tried "-o ro" (which I missed), then my last
suggestion is probably kernel 3.3 with "-o ro". just in case :)

-- 
Fajar
