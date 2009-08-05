From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: snapshot-removal - timeline ?
Date: Wed, 5 Aug 2009 13:18:33 +0200
Message-ID: <5D3C1A84-7A56-48CC-9C78-EDC582ED6B54@karlsbakk.net>
References: <1552F85577A149D68B0BFF2A44E0FF0A@bui.materna.com> <20090803130412.GB3570@think> <10F3F7E4-276B-49C3-B944-61320D634C93@karlsbakk.net> <20090803161800.GB5492@think> <7EC11C2E-889E-42A4-80D8-EA7E80F4963D@karlsbakk.net> <20090804183307.GG5693@think>
Reply-To: linux-btrfs <linux-btrfs@vger.kernel.org>
Mime-Version: 1.0 (Apple Message framework v935.3)
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed	delsp=yes
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090804183307.GG5693@think>
List-ID: <linux-btrfs.vger.kernel.org>

On 4. aug.. 2009, at 20.33, Chris Mason wrote:

>> It's strange that such a small thing should be delayed so much. If
>> snapshot removal was working, I'm quite sure we might get more users
>> and thereby more stable code faster.
>
> It's a small feature but it gets deep into the difficult parts of the
> dentry cache to do it right.  So, it definitely isn't easy.


I'd say it's a pretty elemetary feature to be able to remove something =
=20
you have created. I know, you can remove the files and so on, but =20
still, having a bunch of old and empty snapshots lying around is no =20
good.

roy
--
Roy Sigurd Karlsbakk
(+47) 97542685
roy@karlsbakk.net
http://blogg.karlsbakk.net/
--
I all pedagogikk er det essensielt at pensum presenteres =20
intelligibelt. Det er et element=E6rt imperativ for alle pedagoger =E5 =
=20
unng=E5 eksessiv anvendelse av idiomer med fremmed opprinnelse. I de =20
fleste tilfeller eksisterer adekvate og relevante synonymer p=E5 norsk.

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
