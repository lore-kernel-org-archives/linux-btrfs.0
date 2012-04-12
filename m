From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Subject: Re: [RFC] [PATCH 2/2] Btrfs: move over to use ->update_time
Date: Thu, 12 Apr 2012 14:09:08 +0300
Message-ID: <CALLzPKaiYkp15DnP2m+ZdX+zVpVDWPwU7Ct+MrsetAFYXYR0ig@mail.gmail.com>
References: <1332771031-3337-1-git-send-email-josef@redhat.com>
	<1332771031-3337-2-git-send-email-josef@redhat.com>
	<CALLzPKbs7ALeP9sM2OorMiMFCXGs26oPM9=EjBny0NiQi0orSQ@mail.gmail.com>
	<20120404174300.GB2097@localhost.localdomain>
	<1333561669.12904.0.camel@falcor>
	<CALLzPKYvPqi=9dboZDh4Gm0Poouoa2ZY7K3hbhS9bmkiK6nFAQ@mail.gmail.com>
	<20120404181622.GC2097@localhost.localdomain>
	<20120409151605.GA6482@fieldses.org>
	<20120410074801.GE11041@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: dave@jikos.cz, "J. Bruce Fields" <bfields@fieldses.org>,
	Josef Bacik <josef@redhat.com>,
	"Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>,
	Mimi Zohar <zohar@linux.vnet.ibm.com>,
	linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
	linux-btrfs@vger.kernel.org, hch@infradead.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120410074801.GE11041@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 10, 2012 at 10:48 AM, David Sterba <dave@jikos.cz> wrote:
> On Mon, Apr 09, 2012 at 11:16:05AM -0400, J. Bruce Fields wrote:
>> > Nobody yet, I'm going to send a patch shortly that will support th=
is. =C2=A0Thanks,
>>
>> Great. =C2=A0It would also be far preferable if it was just always o=
n (at
>> least by default) rather than requiring a mount option.
>
> [looks into Josef's patch] it is, no mount option needed.
>

Where is it? Can you please point out?

Thanks.
>
> david
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
