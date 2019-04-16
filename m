Return-Path: <SRS0=AHcI=SS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E38EC10F13
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Apr 2019 23:46:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 575BD20880
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Apr 2019 23:46:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729291AbfDPXp6 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 16 Apr 2019 19:45:58 -0400
Received: from mx0a-002e3701.pphosted.com ([148.163.147.86]:37902 "EHLO
        mx0a-002e3701.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728856AbfDPXp6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 Apr 2019 19:45:58 -0400
Received: from pps.filterd (m0134421.ppops.net [127.0.0.1])
        by mx0b-002e3701.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x3GNflP9000356;
        Tue, 16 Apr 2019 23:45:27 GMT
Received: from g9t5009.houston.hpe.com (g9t5009.houston.hpe.com [15.241.48.73])
        by mx0b-002e3701.pphosted.com with ESMTP id 2rwpjph366-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Apr 2019 23:45:26 +0000
Received: from G2W6311.americas.hpqcorp.net (g2w6311.austin.hp.com [16.197.64.53])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by g9t5009.houston.hpe.com (Postfix) with ESMTPS id 41F0B72;
        Tue, 16 Apr 2019 23:45:24 +0000 (UTC)
Received: from G9W8669.americas.hpqcorp.net (16.220.49.28) by
 G2W6311.americas.hpqcorp.net (16.197.64.53) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 16 Apr 2019 23:45:02 +0000
Received: from G9W9210.americas.hpqcorp.net (2002:10dc:429b::10dc:429b) by
 G9W8669.americas.hpqcorp.net (2002:10dc:311c::10dc:311c) with Microsoft SMTP
 Server (TLS) id 15.0.1367.3; Tue, 16 Apr 2019 23:45:02 +0000
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (15.241.52.13) by
 G9W9210.americas.hpqcorp.net (16.220.66.155) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3 via Frontend Transport; Tue, 16 Apr 2019 23:45:02 +0000
Received: from AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM (10.169.7.147) by
 AT5PR8401MB0372.NAMPRD84.PROD.OUTLOOK.COM (10.169.3.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1792.19; Tue, 16 Apr 2019 23:45:00 +0000
Received: from AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::42e:3524:1bf3:fed2]) by AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::42e:3524:1bf3:fed2%7]) with mapi id 15.20.1792.018; Tue, 16 Apr 2019
 23:45:00 +0000
From:   "Elliott, Robert (Servers)" <elliott@hpe.com>
To:     Goldwyn Rodrigues <rgoldwyn@suse.de>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
CC:     "kilobyte@angband.pl" <kilobyte@angband.pl>,
        "jack@suse.cz" <jack@suse.cz>,
        "darrick.wong@oracle.com" <darrick.wong@oracle.com>,
        "nborisov@suse.com" <nborisov@suse.com>,
        "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>,
        "david@fromorbit.com" <david@fromorbit.com>,
        "dsterba@suse.cz" <dsterba@suse.cz>,
        "willy@infradead.org" <willy@infradead.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "hch@lst.de" <hch@lst.de>, Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: RE: [PATCH 02/18] btrfs: Carve out btrfs_get_extent_map_write() out
 of btrfs_get_blocks_write()
Thread-Topic: [PATCH 02/18] btrfs: Carve out btrfs_get_extent_map_write() out
 of btrfs_get_blocks_write()
Thread-Index: AQHU9HNk8Id3QWceuk+YwitRy94OnaY/c1aQ
Date:   Tue, 16 Apr 2019 23:45:00 +0000
Message-ID: <AT5PR8401MB116964C9F08E4378BDE415F3AB240@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
References: <20190416164154.30390-1-rgoldwyn@suse.de>
 <20190416164154.30390-3-rgoldwyn@suse.de>
In-Reply-To: <20190416164154.30390-3-rgoldwyn@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [15.211.195.7]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3e5119be-30b2-41f5-87ce-08d6c2c58a9f
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600140)(711020)(4605104)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:AT5PR8401MB0372;
x-ms-traffictypediagnostic: AT5PR8401MB0372:
x-microsoft-antispam-prvs: <AT5PR8401MB0372FD5B01B7D69B2844FBD5AB240@AT5PR8401MB0372.NAMPRD84.PROD.OUTLOOK.COM>
x-forefront-prvs: 000947967F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(346002)(376002)(39860400002)(396003)(136003)(199004)(189003)(13464003)(97736004)(186003)(54906003)(316002)(76176011)(229853002)(5660300002)(8936002)(6436002)(305945005)(9686003)(476003)(14454004)(86362001)(52536014)(68736007)(11346002)(74316002)(486006)(25786009)(71190400001)(2906002)(71200400001)(106356001)(6246003)(81156014)(105586002)(81166006)(256004)(8676002)(33656002)(6116002)(478600001)(55016002)(7696005)(446003)(66066001)(53936002)(110136005)(4326008)(99286004)(102836004)(26005)(53546011)(7416002)(4744005)(6506007)(2501003)(3846002)(7736002);DIR:OUT;SFP:1102;SCL:1;SRVR:AT5PR8401MB0372;H:AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: hpe.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: IJIGniMlyk9BsO8TkEcyG+m1ebf8Br0XkvqnET7mR7HzFNXdE3qdxdFGaqSJpVga13QwLN8MxlHYNU2Qjwb1CmZN9Bos8yV+dFV4RuM2/js6mx/yBH36zLR09ygHYxovhzbYH39Ayo9pYfBUjSxEd5IlgCWpjaz/BmT3bDRUCz/b3BZCrh7cLzklBpEJjT8aCYhCiCnmofM5F+e5cnHv4gEVN7J9G1iURRvE4gF/0uTp/pxRNFATbAqN8o7hATv7vR/wVbq19D93np3qRNJ+SCX0hGdiOEIHj1I0P+Z5pTdEeS9q2pve6tf0ZwitpFfCJdtT24GCnyI0juAiDhHi+Nh+/36VtOtBbLNFq6myXUMOZSRtZgk8FPdd6eBQ0n+QnN5XrauBExLVdYXbkWGvJn9D0FFcwq6da/ilYqZXczk=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e5119be-30b2-41f5-87ce-08d6c2c58a9f
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Apr 2019 23:45:00.9190
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AT5PR8401MB0372
X-OriginatorOrg: hpe.com
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-04-16_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=843 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1904160141
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

> -----Original Message-----
> From: Linux-nvdimm [mailto:linux-nvdimm-bounces@lists.01.org] On Behalf Of Goldwyn Rodrigues
> Sent: Tuesday, April 16, 2019 11:42 AM
> Subject: [PATCH 02/18] btrfs: Carve out btrfs_get_extent_map_write() out of btrfs_get_blocks_write()
...
> +static int btrfs_get_blocks_direct_write(struct extent_map **map,
> +					 struct buffer_head *bh_result,
> +					 struct inode *inode,
> +					 struct btrfs_dio_data *dio_data,
> +					 u64 start, u64 len)
> +{
> +	int ret = 0;

That initialization value is not needed, since ret is always overwritten
two lines later.

> +	struct extent_map *em;
> +
> +	ret = btrfs_get_extent_map_write(map, bh_result, inode,
> +			start, len);
> +	if (ret < 0)
> +		return ret;
> +	em = *map;

