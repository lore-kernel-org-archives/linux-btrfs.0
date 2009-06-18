From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: Using SSDs for caching?
Date: Thu, 18 Jun 2009 19:25:46 +0200
Message-ID: <DD311555-2AA3-4487-998F-C232FF3690F1@karlsbakk.net>
References: <D3FA806D-C1A1-455F-A4E0-81AAD3E5C615@karlsbakk.net> <20090618155530.GA16819@mother.pipebreaker.pl>
Reply-To: linux-btrfs <linux-btrfs@vger.kernel.org>
Mime-Version: 1.0 (Apple Message framework v935.3)
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed	delsp=yes
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090618155530.GA16819@mother.pipebreaker.pl>
List-ID: <linux-btrfs.vger.kernel.org>

On 18. juni. 2009, at 17.55, Tomasz Torcz wrote:

> On Thu, Jun 18, 2009 at 03:56:23PM +0200, Roy Sigurd Karlsbakk wrote:
>> I have heard/read about systems from Sun and NetApp using SDs for
>> caching. Sun uses different SDs for read and write caching (one bein=
g
>> faster for reads and the other for writes). The storage solution fro=
m
>> Sun is based on Solaris with ZFS.
>>
>> I know too little about filesystems design to know exactly how they =
=20
>> do
>> this, but can someone think of a way this could be implemented in =20
>> btrfs?
>
>  Linux already has second-level=B9 cache layer, it called FS-Cache. =20
> For now,
> the sole user is NFS. btrfs could take advantage of FS-Cache also.


I googled around a bit for this, but couldn't find anything useful. =20
Where can I find anything about this second (or fifth) level caching?

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
