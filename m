Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f46.google.com ([209.85.192.46]:36380 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529AbbIVRdK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Sep 2015 13:33:10 -0400
Received: by qgx61 with SMTP id 61so122844201qgx.3
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Sep 2015 10:32:58 -0700 (PDT)
Subject: Re: [PATCH] btrfs: Fix no space bug caused by removing bg
To: Hugo Mills <hugo@carfax.org.uk>, dsterba@suse.cz,
        =?UTF-8?Q?Holger_Hoffst=c3=a4tte?=
	<holger.hoffstaette@googlemail.com>,
        linux-btrfs@vger.kernel.org
References: <15fc8f8d002e4ffcdb46e769736f240ae7ace20b.1442839332.git.zhaolei@cn.fujitsu.com>
 <560150CD.6070301@suse.com> <5601596B.1020607@googlemail.com>
 <20150922134131.GH5918@carfax.org.uk> <20150922142333.GH12815@twin.jikos.cz>
 <20150922143602.GI5918@carfax.org.uk> <56016BB5.6060101@gmail.com>
 <20150922153930.GK5918@carfax.org.uk>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <560190CA.7060606@gmail.com>
Date: Tue, 22 Sep 2015 13:32:58 -0400
MIME-Version: 1.0
In-Reply-To: <20150922153930.GK5918@carfax.org.uk>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms070705010000050907020608"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms070705010000050907020608
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-09-22 11:39, Hugo Mills wrote:
> On Tue, Sep 22, 2015 at 10:54:45AM -0400, Austin S Hemmelgarn wrote:
>> On 2015-09-22 10:36, Hugo Mills wrote:
>>> On Tue, Sep 22, 2015 at 04:23:33PM +0200, David Sterba wrote:
>>>> On Tue, Sep 22, 2015 at 01:41:31PM +0000, Hugo Mills wrote:
>>>>> On Tue, Sep 22, 2015 at 03:36:43PM +0200, Holger Hoffst=E4tte wrote=
:
>>>>>> On 09/22/15 14:59, Jeff Mahoney wrote:
>>>>>> (snip)
>>>>>>> So if they way we want to prevent the loss of raid type info is b=
y
>>>>>>> maintaining the last block group allocated with that raid type, f=
ine,
>>>>>>> but that's a separate discussion.  Personally, I think keeping 1G=
B
>>>>>>
>>>>>> At this point I'm much more surprised to learn that the RAID type =
can
>>>>>> apparently get "lost" in the first place, and is not persisted
>>>>>> separately. I mean..wat?
>>>>>
>>>>>     It's always been like that, unfortunately.
>>>>>
>>>>>     The code tries to use the RAID type that's already present to w=
ork
>>>>> out what the next allocation should be. If there aren't any chunks =
in
>>>>> the FS, the configuration is lost, because it's not stored anywhere=

>>>>> else. It's one of the things that tripped me up badly when I was
>>>>> failing to rewrite the chunk allocator last year.
>>>>
>>>> Yeah, right now there's no persistent default for the allocator. I'm=

>>>> still hoping that the object properties will magically solve that.
>>>
>>>     There's no obvious place that filesystem-wide properties can be
>>> stored, though. There's a userspace tool to manipulate the few curren=
t
>>> FS-wide properties, but that's all special-cased to use the
>>> "historical" ioctls for those properties, with no generalisation of a=

>>> property store, or even (IIRC) any external API for them.
>>>
>>>     We're nominally using xattrs in the btrfs: namespace on directori=
es
>>> and files, and presumably on the top directory of a subvolume for
>>> subvol-wide properties, but it's not clear where the FS-wide values
>>> should go: in the top directory of subvolid=3D5 would be confusing,
>>> because then you couldn't separate the properties for *that subvol*
>> >from the ones for the whole FS (say, the default replication policy,
>>> where you might want the top subvol to have different properties from=

>>> everything else).
>> Possibly do special names for the defaults and store them there?  In
>> general, I personally see little value in having some special
>> 'default' properties however.
>
>     That would work.
>
>> The way I would expect things to work is that a new subvolume
>> inherits it's properties from it's parent (if it's a snapshot),
>
>     Definitely this.
>
>> or
>> from the next higher subvolume it's nested in.
>
>     I don't think I like this. I'm not quite sure why, though, at the
> moment.
>
>     It definitely makes the process at the start of allocating a new
> block group much more complex: you have to walk back up through an
> arbitrary depth of nested subvols to find the one that's actually got
> a replication policy record in it. (Because after this feature is
> brought in, there will be lots of filesystems without per-subvol
> replication policies in them, and we have to have some way of dealing
> with those as well).
ro-compat flag perhaps?
>
>     With an FS default policy, you only need check the current subvol,
> and then fall back to the FS default if that's not found.
>
>     These things are, I think, likely to be lightly used: I would be
> reasonably surprised to find more than two or possibly three storage
> policies in use on any given system with a sane sysadmin.
>
>     I'm actually not sure what the interactions of multiple storage
> policies are going to be like. It's entirely possible, particularly
> with some of the more exotic (but useful) suggestions I've thought of,
> that the behaviour of the FS is dependent on the order in which the
> block groups are allocated. (i.e. "20 GiB to subvol-A, then 20 GiB to
> subvol-B" results in different behaviour than "1 GiB to subvol-A then
> 1 GiB to subvol-B and repeat"). I tried some simple Monte-Carlo
> simulations, but I didn't get any concrete results out of it before
> the end of the train journey. :)
Yeah, I could easily see that getting complicated when you add in the=20
(hopefully soon) possibility of n-copy replication.
>
>>   This would obviate
>> the need for some special 'default' properties, and would be
>> relatively intuitive behavior for a significant majority of people.
>
>     Of course, you shouldn't be nesting subvolumes anyway. It makes
> it much harder to manage them.
That depends though, I only ever do single nesting (ie, a subvolume in a =

subvolume), and I use it to exclude stuff from getting saved in=20
snapshots (mostly stuff like clones of public git trees, or other stuff=20
that's easy to reproduce without a backup).  Beyond that though, there=20
are other inherent issues of course.



--------------ms070705010000050907020608
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUwOTIyMTczMjU4WjBPBgkq
hkiG9w0BCQQxQgRAoJNYkSUR+sevvUHT4Xse/GsTcmzq3mDRTXQ4O9rE8GlInsXUXl0fUJNU
5SddUNTrR7c2NFX8vFHb4r6u+zGFPzBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgBOPZnSHJQQX23GJUEtcMT5X96Wqouj/xtPpdUWDFYz9w4N+FKP
d7DwbbbXyxqESdd5Z5RSPjvL/03iHfxnZWaFatTa2ACnH92PuP2LFIkUv2fYz3HZTAaV/FT3
RPzgxLW3XtywfXyR1oNSsEihbvoRcOUi2JhsWT3HJ+08nWgXefbru1HbtS17B/PDNl1gPcB8
AbUPZ9OaJffVHxpgC+u1vVm5kjm+6M/+I5vCvXwNe7tBzlpJeKXyBjAyl69TbeW/N6UIMXO8
x9akwoF4DCP0sBR2V0GPHRtkbtMdRZUvyQw1RIha7fGLwHGK6yyGbwNA3wAQZ03s4frj1guv
NuBr/CSg2dL18fr52Hf9cNOJ5uguLUXeavmNmsz/3Ni3v8mSb9JU/vOVCyIZ5Fh5tpPf3t7e
K+qSl/0ppWtNqDf7iLiOKWoUfjwNrdJ7l1uY9v8x4/mTLAo/htl/eKB7yDI+xPFO2p1isNSf
km2/i0ME0hpjYYpYuYaxCYggjQyXRDr6SGg4H1/39o147TYT70J6jgZE9xrkJKjNgDyn6+bM
Mj9UVBo29HKv+xhvyB6MYZgEC/N7Aj8C95soIxgfglF9Led0LHQyAqqtJxPvWvq1OcDI8DnX
PFBaIBgvVjXIBAZi/081ilsYEQNUIBmIOwkv+JcXC5eLOHbYRF1zZW5BOQAAAAAAAA==
--------------ms070705010000050907020608--
