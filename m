From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: Various Questions
Date: Sun, 9 Jan 2011 20:37:18 +0700
Message-ID: <AANLkTimVie3KOmAh0Ukd8ZoADaGSQHL2YoZVmtxo3cdq@mail.gmail.com>
References: <201101070915.20468.CACook@quantum-sci.com>
	<201101080525.19792.CACook@quantum-sci.com>
	<AANLkTi=HPx1-e09kPg0c6_UQpTCOfPe6-Q4SOUxKLnE=@mail.gmail.com>
	<201101090516.09255.CACook@quantum-sci.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Carl Cook <CACook@quantum-sci.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201101090516.09255.CACook@quantum-sci.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jan 9, 2011 at 8:16 PM, Carl Cook <CACook@quantum-sci.com> wrot=
e:
>
> I'd rather not do the copy again unless necessary, as it took a day.
>
> Directories look identical, but who knows? =A0I'm going to try and fi=
gure out how to do a file-by-file crc check, for peace of mind.

try "du --apparent-size -slh"
It should rule out any differences caused by sparse files and hardlinks=
=2E

>
>
> On Sat 08 January 2011 17:26:25 Freddie Cash wrote:
>> On Sat, Jan 8, 2011 at 5:25 AM, Carl Cook <CACook@quantum-sci.com> w=
rote:
>> >
>> > In addition to the questions below, if anyone has a chance could y=
ou advise on why my destination drive has more data =A0than the source =
after this command:
>> > # rsync --hard-links --delete --inplace --archive --numeric-ids /m=
edia/disk/* /home

Are you SURE you don't get the command mixed up? The last argument to
rsync should be the destination. Your command looks like you're
copying things to /home.

--=20
=46ajar
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
