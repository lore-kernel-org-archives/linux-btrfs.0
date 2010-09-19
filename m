From: C Anthony Risinger <anthony@extof.me>
Subject: Re: Question of stability
Date: Sat, 18 Sep 2010 19:43:59 -0500
Message-ID: <-2391411343414296963@unknownmsgid>
References: <4391908.129.1284854134163.JavaMail.root@zimbra>
Mime-Version: 1.0 (iPhone Mail 7D11)
Content-Type: text/plain; charset=ISO-8859-1
Cc: Hendrik Fabelje <hendrik@fabelje.de>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4391908.129.1284854134163.JavaMail.root@zimbra>
List-ID: <linux-btrfs.vger.kernel.org>

On Sep 18, 2010, at 6:55 PM, Roy Sigurd Karlsbakk <roy@karlsbakk.net>
wrote:

> ----- Original Message -----
>> On Sat, Sep 18, 2010 at 11:37 PM, Roy Sigurd Karlsbakk
>> <roy@karlsbakk.net> wrote:
>>> Hi all
>>>
>>> I've been on this list for a year or so, and I have been following
>>> progress for some more. Are there any chances of btrfs >stabilizing,
>>> as in terms of usability in production? If so, how far are we from
>>> this?
>> Hi,
>>
>> I am using btrfs as my root filesystem on my Debian squeeze machine
>> for a few month now and so far I haven't experienced any problems.
>> It seems quite stable for me. I am not using raid functions, but am
>> also very interested in the progress in raid5/6.
>
> I was more interested in large setups than a general install.
>
> Question remains, when is btrfs supposed to be stable, as in usable
> for large server setups?

Stable is a pretty subjective term; many don't even think ext4 is
stable.  I've used it on my personal machine since .30-31-ish without
problems, and on a server w/raid 1 for about a year (btrfs + lxc is
niiice, for VMs) also free of problems.

However, if you've been on the list you know that some do encounter
seemingly catastrophic problems, though the list is helpful in
recovering data.  So, it's really going to depends on your workload
and integrity needs.  I remeber someone recently using it for
continuous build servers successfully
